import com.google.gson.Gson
import com.slack.api.Slack
import com.slack.api.webhook.WebhookPayloads
import java.io.InputStream
import java.io.OutputStream

class Main {

    val NOTIFY_URL = "<enter webook url here>"

    private val gson by lazy { Gson() }

    fun parseInput(rawInput: InputStream) = gson.fromJson(
        rawInput.reader().readText(),
        SnsPayload::class.java
    )

    fun parseLambdaResultIfAny(content: SnsRecordContent) = try {
        gson.fromJson(content.Message, LambdaMessage::class.java)
            ?.responsePayload?.errorMessage
    } catch (e : Exception) {
        null
    }

    fun handle(rawInput: InputStream, output: OutputStream) {

        val input = parseInput(rawInput)

        val slack = Slack.getInstance()
        input.Records.forEach {record ->
            val message = parseLambdaResultIfAny(record.Sns)
                ?: record.Sns.Message
            slack.httpClient.postJsonBody(
                NOTIFY_URL,
                WebhookPayloads.payload {
                    it.text("${record.Sns.Subject ?: ""}\n$message")
                }
            )

        }

    }

    data class SnsRecordContent(
        val Subject: String?,
        val Message: String
    )

    data class SnsRecord(
        val Sns: SnsRecordContent
    )

    data class SnsPayload(
        val Records: List<SnsRecord>
    )

    data class LambdaMessage(
        val responsePayload: ResponsePayload
    )

    data class ResponsePayload(
        val errorMessage: String
    )
}
