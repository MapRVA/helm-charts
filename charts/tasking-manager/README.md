# Tasking Manager Helm Chart

This is an experiment in deploying the HOT Tasking Manager to Kubernetes.

See the MapRVA/tasking-manager repository for more.

```yaml
# Example custom values for your Tasking Manager deployment

baseUrl: <BASE URL>
apiUrl: <API URL>
secret: <SECRET HERE>

org:
  name: <NAME OF ORG>
  code: <ORG CODE>
  url: <ORG URL>
  logoUrl: https://cdn.img.url/logo.png
  github: <GITHUB URL>

oAuth2:
  clientId: <CLIENT ID>
  clientSecret: <CLIENT SECRET>
  redirectUri: <REDIRECT URI>

ohsome:
  apiToken: <API TOKEN HERE>

email:
  smtpHost: smtp.gmail.com
  smtpPort: "587"
  smtpUser: <EMAIL HERE>
  smtpPassword: <PASSWORD HERE>
  smtpUseTls: "0"
  smtpUseSsl: "1"
  sendProjectEmailUpdates: "-1"
```
