Using password authentication.
#!/bin/sh
sudo curl -f --create-dirs -o /opt/arc/arc https://stable.arc.eu-de-1.cloud.sap/arc/linux/amd64/latest
sudo chmod +x /opt/arc/arc
sudo /opt/arc/arc init --endpoint tls://arc-broker.eu-de-1.cloud.sap:8883 --update-uri https://stable.arc.eu-de-1.cloud.sap --registration-url https://arc.eu-de-1.cloud.sap/api/v1/agents/init/dc4a2c3f-18b6-4be3-aabc-2c0babdb21d3
