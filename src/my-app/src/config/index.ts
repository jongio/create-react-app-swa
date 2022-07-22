export interface ObservabilityConfig {
  connectionString: string;
}

export interface AppConfig {
  observability: ObservabilityConfig;
}

const config: AppConfig = {
  observability: {
    connectionString:
      window.ENV_CONFIG.REACT_APP_APPLICATIONINSIGHTS_CONNECTION_STRING || "",
  },
};

export default config;
