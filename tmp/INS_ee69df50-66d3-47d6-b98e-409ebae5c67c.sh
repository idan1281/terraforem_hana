Using password authentication.
#!/bin/sh
sudo curl -f --create-dirs -o /opt/arc/arc https://stable.arc.eu-de-1.cloud.sap/arc/linux/amd64/latest
sudo chmod +x /opt/arc/arc
sudo /opt/arc/arc init --endpoint tls://arc-broker.eu-de-1.cloud.sap:8883 --update-uri https://stable.arc.eu-de-1.cloud.sap --registration-url https://arc.eu-de-1.cloud.sap/api/v1/agents/init/82a63787-0cf5-4639-849e-5a0923b9d4ca

