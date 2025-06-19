// AI model providers and their models
export interface AIModel {
  id: string;
  name: string;
  description: string;
  provider: string;
  apiEndpoint?: string;
}

export interface Provider {
  id: string;
  name: string;
  logoUrl: string;
  apiKeyName: string;
  apiKeyPlaceholder: string;
  models: AIModel[];
}

const providers: Provider[] = [
  {
    id: "openai",
    name: "OpenAI",
    logoUrl: "https://images.unsplash.com/photo-1591453089816-0fbb971b454c?q=80&w=100&auto=format&fit=crop",
    apiKeyName: "OpenAI API Key",
    apiKeyPlaceholder: "sk-...",
    models: [
      {
        id: "gpt-4o",
        name: "GPT-4o",
        description: "Most capable model for complex tasks",
        provider: "openai",
      },
      {
        id: "gpt-4-turbo",
        name: "GPT-4 Turbo",
        description: "Fast and powerful for most tasks",
        provider: "openai",
      },
      {
        id: "gpt-3.5-turbo",
        name: "GPT-3.5 Turbo",
        description: "Fast and cost-effective",
        provider: "openai",
      },
    ],
  },
  {
    id: "anthropic",
    name: "Anthropic",
    logoUrl: "https://images.unsplash.com/photo-1620712943543-bcc4688e7485?q=80&w=100&auto=format&fit=crop",
    apiKeyName: "Anthropic API Key",
    apiKeyPlaceholder: "sk-ant-...",
    models: [
      {
        id: "claude-3-opus",
        name: "Claude 3 Opus",
        description: "Most powerful Claude model",
        provider: "anthropic",
      },
      {
        id: "claude-3-sonnet",
        name: "Claude 3 Sonnet",
        description: "Balanced performance and speed",
        provider: "anthropic",
      },
      {
        id: "claude-3-haiku",
        name: "Claude 3 Haiku",
        description: "Fast and efficient",
        provider: "anthropic",
      },
    ],
  },
  {
    id: "mistral",
    name: "Mistral AI",
    logoUrl: "https://images.unsplash.com/photo-1639762681057-408e52192e55?q=80&w=100&auto=format&fit=crop",
    apiKeyName: "Mistral API Key",
    apiKeyPlaceholder: "YOUR_MISTRAL_API_KEY",
    models: [
      {
        id: "mistral-large",
        name: "Mistral Large",
        description: "Most capable Mistral model",
        provider: "mistral",
      },
      {
        id: "mistral-medium",
        name: "Mistral Medium",
        description: "Balanced performance",
        provider: "mistral",
      },
      {
        id: "mistral-small",
        name: "Mistral Small",
        description: "Fast and efficient",
        provider: "mistral",
      },
    ],
  },
  {
    id: "groq",
    name: "Groq",
    logoUrl: "https://images.unsplash.com/photo-1518770660439-4636190af475?q=80&w=100&auto=format&fit=crop",
    apiKeyName: "Groq API Key",
    apiKeyPlaceholder: "gsk_...",
    models: [
      {
        id: "llama3-70b-8192",
        name: "LLaMA 3 70B",
        description: "High performance with fast inference",
        provider: "groq",
      },
      {
        id: "llama3-8b-8192",
        name: "LLaMA 3 8B",
        description: "Fast and efficient",
        provider: "groq",
      },
      {
        id: "mixtral-8x7b-32768",
        name: "Mixtral 8x7B",
        description: "Balanced performance",
        provider: "groq",
      },
    ],
  },
  {
    id: "cohere",
    name: "Cohere",
    logoUrl: "https://images.unsplash.com/photo-1558494949-ef010cbdcc31?q=80&w=100&auto=format&fit=crop",
    apiKeyName: "Cohere API Key",
    apiKeyPlaceholder: "YOUR_COHERE_API_KEY",
    models: [
      {
        id: "command-r-plus",
        name: "Command R+",
        description: "Most capable Cohere model",
        provider: "cohere",
      },
      {
        id: "command-r",
        name: "Command R",
        description: "Balanced performance",
        provider: "cohere",
      },
    ],
  },
];

export default providers;
