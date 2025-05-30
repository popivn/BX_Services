FROM mcr.microsoft.com/dotnet/sdk:8.0 AS base
WORKDIR /app
EXPOSE 80

FROM base AS build
WORKDIR /src
COPY ["BX_Services.csproj", "./"]
RUN dotnet restore "BX_Services.csproj"
COPY . .
WORKDIR "/src"
RUN dotnet build "BX_Services.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "BX_Services.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "watch", "run", "--no-launch-profile"] 