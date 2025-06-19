import * as webllm from "@mlc-ai/web-llm"

export interface LocalModel {
  id: string
  name: string
  size: string
  description: string
  downloaded: boolean
  downloading: boolean
  progress: number
}

export interface ChatMessage {
  role: "user" | "assistant"
  content: string
}

class LocalAIService {
  private engine: webllm.MLCEngine | null = null
  private currentModel: string | null = null
  private downloadProgress: Map<string, number> = new Map()
  private downloadCallbacks: Map<string, (progress: number) => void> = new Map()

  // Available local models
  public readonly availableModels: LocalModel[] = [
    {
      id: "Llama-3.2-3B-Instruct-q4f32_1-MLC",
      name: "Llama 3.2 3B",
      size: "2.0 GB",
      description: "Fast and efficient model for general conversations",
      downloaded: false,
      downloading: false,
      progress: 0,
    },
    {
      id: "Phi-3.5-mini-instruct-q4f16_1-MLC",
      name: "Phi 3.5 Mini",
      size: "2.2 GB",
      description: "Microsoft's compact model optimized for mobile",
      downloaded: false,
      downloading: false,
      progress: 0,
    },
    {
      id: "Qwen2.5-1.5B-Instruct-q4f16_1-MLC",
      name: "Qwen 2.5 1.5B",
      size: "1.0 GB",
      description: "Lightweight model for basic conversations",
      downloaded: false,
      downloading: false,
      progress: 0,
    },
    {
      id: "gemma-2-2b-it-q4f16_1-MLC",
      name: "Gemma 2 2B",
      size: "1.4 GB",
      description: "Google's efficient model for mobile devices",
      downloaded: false,
      downloading: false,
      progress: 0,
    },
  ]

  async isSupported(): Promise<boolean> {
    try {
      return (await webllm.hasModelInCache("Llama-3.2-3B-Instruct-q4f32_1-MLC")) !== undefined
    } catch {
      return false
    }
  }

  async getDownloadedModels(): Promise<string[]> {
    try {
      const models = []
      for (const model of this.availableModels) {
        const hasModel = await webllm.hasModelInCache(model.id)
        if (hasModel) {
          models.push(model.id)
        }
      }
      return models
    } catch (error) {
      console.error("Error checking downloaded models:", error)
      return []
    }
  }

  async downloadModel(modelId: string, onProgress?: (progress: number) => void): Promise<void> {
    try {
      if (onProgress) {
        this.downloadCallbacks.set(modelId, onProgress)
      }

      const initProgressCallback = (report: webllm.InitProgressReport) => {
        const progress = Math.round((report.progress || 0) * 100)
        this.downloadProgress.set(modelId, progress)

        const callback = this.downloadCallbacks.get(modelId)
        if (callback) {
          callback(progress)
        }
      }

      // Create engine with progress callback
      this.engine = new webllm.MLCEngine()
      await this.engine.reload(modelId, undefined, {
        initProgressCallback,
      })

      this.currentModel = modelId
      this.downloadCallbacks.delete(modelId)
    } catch (error) {
      console.error("Error downloading model:", error)
      this.downloadCallbacks.delete(modelId)
      throw error
    }
  }

  async loadModel(modelId: string): Promise<void> {
    try {
      if (this.currentModel === modelId && this.engine) {
        return // Model already loaded
      }

      if (!this.engine) {
        this.engine = new webllm.MLCEngine()
      }

      await this.engine.reload(modelId)
      this.currentModel = modelId
    } catch (error) {
      console.error("Error loading model:", error)
      throw error
    }
  }

  async deleteModel(modelId: string): Promise<void> {
    try {
      // If this is the currently loaded model, unload it
      if (this.currentModel === modelId) {
        this.engine = null
        this.currentModel = null
      }

      // Delete from cache
      await webllm.deleteModelInCache(modelId)
    } catch (error) {
      console.error("Error deleting model:", error)
      throw error
    }
  }

  async chat(messages: ChatMessage[]): Promise<AsyncIterable<string>> {
    if (!this.engine || !this.currentModel) {
      throw new Error("No model loaded")
    }

    try {
      const stream = await this.engine.chat.completions.create({
        messages: messages.map((msg) => ({
          role: msg.role,
          content: msg.content,
        })),
        temperature: 0.7,
        stream: true,
      })

      return this.createAsyncIterable(stream)
    } catch (error) {
      console.error("Error in local chat:", error)
      throw error
    }
  }

  private async *createAsyncIterable(stream: any): AsyncIterable<string> {
    try {
      for await (const chunk of stream) {
        const delta = chunk.choices[0]?.delta?.content
        if (delta) {
          yield delta
        }
      }
    } catch (error) {
      console.error("Error in stream:", error)
      throw error
    }
  }

  async getModelInfo(modelId: string): Promise<any> {
    try {
      const hasModel = await webllm.hasModelInCache(modelId)
      return {
        downloaded: !!hasModel,
        size: await this.getModelSize(modelId),
      }
    } catch (error) {
      console.error("Error getting model info:", error)
      return { downloaded: false, size: 0 }
    }
  }

  private async getModelSize(modelId: string): Promise<number> {
    // This is an approximation - WebLLM doesn't provide exact size info
    const sizeMap: Record<string, number> = {
      "Llama-3.2-3B-Instruct-q4f32_1-MLC": 2000,
      "Phi-3.5-mini-instruct-q4f16_1-MLC": 2200,
      "Qwen2.5-1.5B-Instruct-q4f16_1-MLC": 1000,
      "gemma-2-2b-it-q4f16_1-MLC": 1400,
    }
    return sizeMap[modelId] || 1000
  }

  getDownloadProgress(modelId: string): number {
    return this.downloadProgress.get(modelId) || 0
  }

  isModelLoaded(modelId: string): boolean {
    return this.currentModel === modelId && this.engine !== null
  }
}

export const localAI = new LocalAIService()
