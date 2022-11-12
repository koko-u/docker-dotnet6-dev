FROM mcr.microsoft.com/dotnet/sdk:6.0.403-focal

RUN apt update && apt upgrade -y
RUN apt install -y libnss3-tools

RUN mkdir -p /root/.pki/nssdb
RUN dotnet dev-certs https --export-path /usr/local/share/ca-certificates/aspnet/https.crt \
    --format PEM --password TpdjDNNcSwRb1
RUN certutil -d sql:/root/.pki/nssdb -A -t "P,," -n localhost -i /usr/local/share/ca-certificates/aspnet/https.crt
RUN certutil -d sql:/root/.pki/nssdb -A -t "C,," -n localhost -i /usr/local/share/ca-certificates/aspnet/https.crt

RUN dotnet tool install --global dotnet-ef --version 6.0.11
RUN dotnet tool install --global Microsoft.Web.LibraryManager.Cli
RUN printf "\n\nexport PATH="$PATH:/root/.dotnet/tools"" >> /root/.bashrc

WORKDIR /usr/workspace

COPY workspace.code-workspace /root/


CMD [ "/bin/bash" ]