import { openai } from "@ai-sdk/openai"
import { anthropic } from "@ai-sdk/anthropic"
import { google } from "@ai-sdk/google"
import { xai } from "@ai-sdk/xai"
import { groq } from "@ai-sdk/groq"

export interface AIModel {
  id: string
  name: string
  description?: string
  isLocal?: boolean
  size?: string
}

export interface AIProvider {
  id: string
  name: string
  description: string
  models: AIModel[]
  isLocal?: boolean
}

export const AI_PROVIDERS: AIProvider[] = [
  {
    id: "local",
    name: "Local Models",
    description: "AI models running locally on your device",
    isLocal: true,
    models: [
      {
        id: "Llama-3.2-3B-Instruct-q4f32_1-MLC",
        name: "Llama 3.2 3B",
        description: "Fast and efficient model for general conversations",
        isLocal: true,
        size: "2.0 GB",
      },
      {
        id: "Phi-3.5-mini-instruct-q4f16_1-MLC",
        name: "Phi 3.5 Mini",
        description: "Microsoft's compact model optimized for mobile",
        isLocal: true,
        size: "2.2 GB",
      },
      {
        id: "Qwen2.5-1.5B-Instruct-q4f16_1-MLC",
        name: "Qwen 2.5 1.5B",
        description: "Lightweight model for basic conversations",
        isLocal: true,
        size: "1.0 GB",
      },
      {
        id: "gemma-2-2b-it-q4f16_1-MLC",
        name: "Gemma 2 2B",
        description: "Google's efficient model for mobile devices",
        isLocal: true,
        size: "1.4 GB",
      },
    ],
  },
  {
    id: "openai",
    name: "OpenAI",
    description: "Get your API key from platform.openai.com",
    models: [
      { id: "gpt-4o", name: "GPT-4o", description: "Most capable model" },
      { id: "gpt-4o-mini", name: "GPT-4o Mini", description: "Fast and efficient" },
      { id: "gpt-4-turbo", name: "GPT-4 Turbo", description: "Previous generation flagship" },
      { id: "gpt-3.5-turbo", name: "GPT-3.5 Turbo", description: "Fast and cost-effective" },
    ],
  },
  {
    id: "anthropic",
    name: "Anthropic",
    description: "Get your API key from console.anthropic.com",
    models: [
      { id: "claude-3-5-sonnet-20241022", name: "Claude 3.5 Sonnet", description: "Most capable model" },
      { id: "claude-3-5-haiku-20241022", name: "Claude 3.5 Haiku", description: "Fast and efficient" },
      { id: "claude-3-opus-20240229", name: "Claude 3 Opus", description: "Most powerful model" },
    ],
  },
  {
    id: "google",
    name: "Google",
    description: "Get your API key from aistudio.google.com",
    models: [
      { id: "gemini-1.5-pro", name: "Gemini 1.5 Pro", description: "Most capable model" },
      { id: "gemini-1.5-flash", name: "Gemini 1.5 Flash", description: "Fast and efficient" },
      { id: "gemini-pro", name: "Gemini Pro", description: "Balanced performance" },
    ],
  },
  {
    id: "xai",
    name: "xAI",
    description: "Get your API key from console.x.ai",
    models: [
      { id: "grok-3", name: "Grok 3", description: "Latest and most capable" },
      { id: "grok-2", name: "Grok 2", description: "Previous generation" },
    ],
  },
  {
    id: "groq",
    name: "Groq",
    description: "Get your API key from console.groq.com",
    models: [
      { id: "llama-3.3-70b-versatile", name: "Llama 3.3 70B", description: "Most capable open model" },
      { id: "llama-3.1-8b-instant", name: "Llama 3.1 8B", description: "Fast and efficient" },
      { id: "mixtral-8x7b-32768", name: "Mixtral 8x7B", description: "Mixture of experts model" },
    ],
  },
]

export function getProviderModel(provider: string, model: string, apiKey?: string) {
  if (provider === "local") {
    // Return a special identifier for local models
    return { provider: "local", model }
  }

  switch (provider) {
    case "openai":
      return openai(model, { apiKey })
    case "anthropic":
      return anthropic(model, { apiKey })
    case "google":
      return google(model, { apiKey })
    case "xai":
      return xai(model, { apiKey })
    case "groq":
      return groq(model, { apiKey })
    default:
      throw new Error(`Unsupported provider: ${provider}`)
  }
}
