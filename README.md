# itemdag-aws-lambda-demo
Demo som viser et AWS lambda-bsaert oppsett for å overvåke status på en nettside ved å lete etter en gitt tekst-streng

Dersom teksten ikke finnes så vil det komme en melding i #lambda-alerts-kanalen etter noen minutter

(Det finnes det selvfølgelig egne verktøy for som er mer egnet)

For å opprette infrastruktur i AWS så trenger du å ha tilgang til Items AWS-konto, evt så må du endre S3 bucket-navn og laste opp lambdaene der selv.

Deretter:

````
cd terraform
terraform init
terraform apply (her blir du spurt om navnet ditt, skriv det inn i CamelCase, uten mellomrom)
````


