import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import okhttp3.OkHttpClient
import okhttp3.Request
import java.io.InputStream
import java.io.OutputStream

class Main {


    data class Input(
        val url: String,
        val searchFor: String
    )

    data class Result(
        val success: Boolean,
        val message: String
    )

    fun checkUrl(url: String, searchFor: String): Result {
        val client = OkHttpClient.Builder()
            .build()
        val result = client.newCall(Request.Builder().get().url(url).build()).execute()
        return result.use {
            if (it.code != 200) {
                Result(false, "Got HTTP code ${it.code}")
            } else {
                checkForExpectedText(url, result.body?.string() ?: "", searchFor)
            }

        }
    }

    private fun checkForExpectedText(url: String, result: String, searchFor: String) = if (!result.contains(searchFor)) {
        Result(false, "Did not find expected text '$searchFor' on $url")
    } else {
        Result(true, "Found expected text")
    }

    fun handle(rawInput: InputStream, output: OutputStream) {

        val objectMapper = jacksonObjectMapper()
        val input = objectMapper.readValue(rawInput, Input::class.java)

        System.out.printf("Called with arguments: $input\n")
        val result = checkUrl(input.url, input.searchFor)

        if (result.success) {
            System.out.printf("Found expected text '${input.searchFor}' on ${input.url}\n")
            objectMapper.writeValue(
                output,
                result
            )
            return
        }

        System.out.printf("Website is not OK: $result\n")
        objectMapper.writeValue(
            output,
            result
        )

        throw Exception(result.message)
    }
}
