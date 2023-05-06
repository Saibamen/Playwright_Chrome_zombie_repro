#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

#FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
#WORKDIR /app
#EXPOSE 80
#EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["Playwright_Chrome_zombie_repro.csproj", "."]
RUN dotnet restore "./Playwright_Chrome_zombie_repro.csproj"
COPY . .
WORKDIR "/src/."
#RUN dotnet build "Playwright_Chrome_zombie_repro.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Playwright_Chrome_zombie_repro.csproj" -c Release -o /app/publish /p:UseAppHost=false

#FROM base AS final
#WORKDIR /app
#COPY --from=publish /app/publish .
#ENTRYPOINT ["dotnet", "Playwright_Chrome_zombie_repro.dll"]



# Playwright (for PDF print)
FROM mcr.microsoft.com/playwright:v1.33.0-focal AS playwright
# Ubuntu version from playwright image
ARG UBUNTU_VERSION=20.04
RUN wget https://packages.microsoft.com/config/ubuntu/${UBUNTU_VERSION}/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    aspnetcore-runtime-6.0 \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 80
ENV ASPNETCORE_URLS=http://+:80

WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Playwright_Chrome_zombie_repro.dll"]
