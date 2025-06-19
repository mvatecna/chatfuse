"use client"

import { useState, useEffect } from "react"
import { Check, Download, Wifi, WifiOff } from "lucide-react"
import { Button } from "@/components/ui/button"
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "@/components/ui/dialog"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Badge } from "@/components/ui/badge"
import { AI_PROVIDERS } from "@/lib/ai-providers"
import { getApiKey } from "@/lib/storage"
import { localAI } from "@/lib/local-ai"

interface ModelSelectorProps {
  open: boolean
  onClose: () => void
  onSelect: (provider: string, model: string) => void
}

export function ModelSelector({ open, onClose, onSelect }: ModelSelectorProps) {
  const [selectedProvider, setSelectedProvider] = useState<string>("")
  const [selectedModel, setSelectedModel] = useState<string>("")
  const [downloadedLocalModels, setDownloadedLocalModels] = useState<string[]>([])
  const [isOnline, setIsOnline] = useState(true)

  useEffect(() => {
    checkDownloadedModels()

    // Check online status
    const updateOnlineStatus = () => setIsOnline(navigator.onLine)
    window.addEventListener("online", updateOnlineStatus)
    window.addEventListener("offline", updateOnlineStatus)

    return () => {
      window.removeEventListener("online", updateOnlineStatus)
      window.removeEventListener("offline", updateOnlineStatus)
    }
  }, [])

  const checkDownloadedModels = async () => {
    try {
      const downloaded = await localAI.getDownloadedModels()
      setDownloadedLocalModels(downloaded)
    } catch (error) {
      console.error("Error checking downloaded models:", error)
    }
  }

  const getAvailableProviders = () => {
    return AI_PROVIDERS.filter((provider) => {
      if (provider.isLocal) {
        // Show local provider if any models are downloaded
        return downloadedLocalModels.length > 0
      }
      // Show online providers if online and have API key
      return isOnline && getApiKey(provider.id) !== null
    })
  }

  const availableProviders = getAvailableProviders()
  const selectedProviderData = AI_PROVIDERS.find((p) => p.id === selectedProvider)

  const getAvailableModels = () => {
    if (!selectedProviderData) return []

    if (selectedProviderData.isLocal) {
      // Only show downloaded local models
      return selectedProviderData.models.filter((model) => downloadedLocalModels.includes(model.id))
    }

    return selectedProviderData.models
  }

  const handleSelect = () => {
    if (selectedProvider && selectedModel) {
      onSelect(selectedProvider, selectedModel)
      setSelectedProvider("")
      setSelectedModel("")
    }
  }

  return (
    <Dialog open={open} onOpenChange={onClose}>
      <DialogContent className="sm:max-w-md">
        <DialogHeader>
          <DialogTitle className="flex items-center gap-2">
            Select AI Model
            {isOnline ? (
              <Badge variant="outline" className="text-green-600">
                <Wifi className="w-3 h-3 mr-1" />
                Online
              </Badge>
            ) : (
              <Badge variant="outline" className="text-orange-600">
                <WifiOff className="w-3 h-3 mr-1" />
                Offline
              </Badge>
            )}
          </DialogTitle>
        </DialogHeader>

        <div className="space-y-4">
          {availableProviders.length === 0 ? (
            <div className="text-center py-8">
              <p className="text-gray-500 dark:text-gray-400 mb-4">
                {!isOnline
                  ? "No local models available. Download models in settings to chat offline."
                  : "No API keys configured and no local models available."}
              </p>
              <Button variant="outline" onClick={onClose}>
                Go to Settings
              </Button>
            </div>
          ) : (
            <>
              <div>
                <label className="text-sm font-medium text-gray-700 dark:text-gray-300 mb-2 block">Provider</label>
                <Select value={selectedProvider} onValueChange={setSelectedProvider}>
                  <SelectTrigger>
                    <SelectValue placeholder="Select a provider" />
                  </SelectTrigger>
                  <SelectContent>
                    {availableProviders.map((provider) => (
                      <SelectItem key={provider.id} value={provider.id}>
                        <div className="flex items-center gap-2">
                          <span>{provider.name}</span>
                          {provider.isLocal ? (
                            <Badge variant="secondary" className="text-xs">
                              <Download className="w-3 h-3 mr-1" />
                              Local
                            </Badge>
                          ) : (
                            <Check className="w-4 h-4 text-green-500" />
                          )}
                        </div>
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>

              {selectedProviderData && (
                <div>
                  <label className="text-sm font-medium text-gray-700 dark:text-gray-300 mb-2 block">Model</label>
                  <Select value={selectedModel} onValueChange={setSelectedModel}>
                    <SelectTrigger>
                      <SelectValue placeholder="Select a model" />
                    </SelectTrigger>
                    <SelectContent>
                      {getAvailableModels().map((model) => (
                        <SelectItem key={model.id} value={model.id}>
                          <div>
                            <div className="font-medium flex items-center gap-2">
                              {model.name}
                              {model.isLocal && (
                                <Badge variant="outline" className="text-xs">
                                  {model.size}
                                </Badge>
                              )}
                            </div>
                            {model.description && <div className="text-xs text-gray-500">{model.description}</div>}
                          </div>
                        </SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                </div>
              )}

              <div className="flex gap-2 pt-4">
                <Button variant="outline" onClick={onClose} className="flex-1">
                  Cancel
                </Button>
                <Button onClick={handleSelect} disabled={!selectedProvider || !selectedModel} className="flex-1">
                  Start Chat
                </Button>
              </div>
            </>
          )}
        </div>
      </DialogContent>
    </Dialog>
  )
}
