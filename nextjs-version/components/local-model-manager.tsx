"use client"

import { useState, useEffect } from "react"
import { Download, Trash2, HardDrive, Wifi, WifiOff, CheckCircle, AlertCircle } from "lucide-react"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Progress } from "@/components/ui/progress"
import { Badge } from "@/components/ui/badge"
import { localAI, type LocalModel } from "@/lib/local-ai"
import { CapacitorService } from "@/lib/capacitor"

interface LocalModelManagerProps {
  onModelReady?: (modelId: string) => void
}

export function LocalModelManager({ onModelReady }: LocalModelManagerProps) {
  const [models, setModels] = useState<LocalModel[]>(localAI.availableModels)
  const [isSupported, setIsSupported] = useState(false)
  const [downloadingModels, setDownloadingModels] = useState<Set<string>>(new Set())
  const [downloadProgress, setDownloadProgress] = useState<Record<string, number>>({})
  const [isOnline, setIsOnline] = useState(true)

  useEffect(() => {
    checkSupport()
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

  const checkSupport = async () => {
    try {
      const supported = await localAI.isSupported()
      setIsSupported(supported)
    } catch (error) {
      console.error("Error checking WebLLM support:", error)
      setIsSupported(false)
    }
  }

  const checkDownloadedModels = async () => {
    try {
      const downloadedIds = await localAI.getDownloadedModels()
      setModels((prev) =>
        prev.map((model) => ({
          ...model,
          downloaded: downloadedIds.includes(model.id),
        })),
      )
    } catch (error) {
      console.error("Error checking downloaded models:", error)
    }
  }

  const handleDownload = async (model: LocalModel) => {
    if (!isOnline) {
      alert("Internet connection required to download models")
      return
    }

    try {
      await CapacitorService.hapticFeedback()

      setDownloadingModels((prev) => new Set([...prev, model.id]))
      setModels((prev) => prev.map((m) => (m.id === model.id ? { ...m, downloading: true } : m)))

      await localAI.downloadModel(model.id, (progress) => {
        setDownloadProgress((prev) => ({ ...prev, [model.id]: progress }))
        setModels((prev) => prev.map((m) => (m.id === model.id ? { ...m, progress } : m)))
      })

      setModels((prev) =>
        prev.map((m) => (m.id === model.id ? { ...m, downloaded: true, downloading: false, progress: 100 } : m)),
      )

      if (onModelReady) {
        onModelReady(model.id)
      }
    } catch (error) {
      console.error("Error downloading model:", error)
      alert("Failed to download model. Please try again.")
      setModels((prev) => prev.map((m) => (m.id === model.id ? { ...m, downloading: false, progress: 0 } : m)))
    } finally {
      setDownloadingModels((prev) => {
        const newSet = new Set(prev)
        newSet.delete(model.id)
        return newSet
      })
    }
  }

  const handleDelete = async (model: LocalModel) => {
    try {
      await CapacitorService.hapticFeedback()

      if (confirm(`Delete ${model.name}? This will free up ${model.size} of storage.`)) {
        await localAI.deleteModel(model.id)
        setModels((prev) => prev.map((m) => (m.id === model.id ? { ...m, downloaded: false, progress: 0 } : m)))
      }
    } catch (error) {
      console.error("Error deleting model:", error)
      alert("Failed to delete model. Please try again.")
    }
  }

  if (!isSupported) {
    return (
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <AlertCircle className="w-5 h-5 text-orange-500" />
            Local Models Not Supported
          </CardTitle>
          <CardDescription>
            Your device or browser doesn't support running local AI models. This feature requires WebGPU support.
          </CardDescription>
        </CardHeader>
      </Card>
    )
  }

  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between">
        <div>
          <h3 className="text-lg font-semibold">Local AI Models</h3>
          <p className="text-sm text-gray-500 dark:text-gray-400">Download models to chat offline</p>
        </div>
        <div className="flex items-center gap-2">
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
        </div>
      </div>

      <div className="grid gap-4">
        {models.map((model) => (
          <Card key={model.id}>
            <CardHeader className="pb-3">
              <div className="flex items-start justify-between">
                <div>
                  <CardTitle className="text-base flex items-center gap-2">
                    {model.name}
                    {model.downloaded && <CheckCircle className="w-4 h-4 text-green-500" />}
                  </CardTitle>
                  <CardDescription className="text-sm">{model.description}</CardDescription>
                </div>
                <Badge variant="secondary" className="text-xs">
                  <HardDrive className="w-3 h-3 mr-1" />
                  {model.size}
                </Badge>
              </div>
            </CardHeader>

            <CardContent className="pt-0">
              {model.downloading && (
                <div className="space-y-2 mb-3">
                  <div className="flex justify-between text-sm">
                    <span>Downloading...</span>
                    <span>{downloadProgress[model.id] || 0}%</span>
                  </div>
                  <Progress value={downloadProgress[model.id] || 0} />
                </div>
              )}

              <div className="flex gap-2">
                {!model.downloaded && !model.downloading && (
                  <Button onClick={() => handleDownload(model)} disabled={!isOnline} size="sm" className="flex-1">
                    <Download className="w-4 h-4 mr-2" />
                    Download
                  </Button>
                )}

                {model.downloaded && (
                  <Button onClick={() => handleDelete(model)} variant="outline" size="sm" className="flex-1">
                    <Trash2 className="w-4 h-4 mr-2" />
                    Delete
                  </Button>
                )}
              </div>
            </CardContent>
          </Card>
        ))}
      </div>
    </div>
  )
}
