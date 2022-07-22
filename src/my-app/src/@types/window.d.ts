export { };

declare global {
    interface Window {
        ENV_CONFIG: {
            REACT_APP_APPLICATIONINSIGHTS_CONNECTION_STRING: string;
        }
    }
}
