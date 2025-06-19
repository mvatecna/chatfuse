import { create } from "zustand";
import { persist, createJSONStorage } from "zustand/middleware";
import AsyncStorage from "@react-native-async-storage/async-storage";
import { ApiKey } from "@/types/chat";

interface ApiKeyState {
  apiKeys: ApiKey[];
  addApiKey: (apiKey: ApiKey) => void;
  updateApiKey: (providerId: string, key: string) => void;
  deleteApiKey: (providerId: string) => void;
  getApiKey: (providerId: string) => string | null;
}

const useApiKeyStore = create<ApiKeyState>()(
  persist(
    (set, get) => ({
      apiKeys: [],
      addApiKey: (apiKey: ApiKey) => {
        set((state) => {
          // Check if key already exists
          const existingKeyIndex = state.apiKeys.findIndex((key) => key.providerId === apiKey.providerId);

          if (existingKeyIndex >= 0) {
            // Update existing key
            const updatedKeys = [...state.apiKeys];
            updatedKeys[existingKeyIndex] = apiKey;
            return { apiKeys: updatedKeys };
          } else {
            // Add new key
            return { apiKeys: [...state.apiKeys, apiKey] };
          }
        });
      },
      updateApiKey: (providerId: string, key: string) => {
        set((state) => {
          const existingKeyIndex = state.apiKeys.findIndex((apiKey) => apiKey.providerId === providerId);

          if (existingKeyIndex >= 0) {
            const updatedKeys = [...state.apiKeys];
            updatedKeys[existingKeyIndex] = { providerId, key };
            return { apiKeys: updatedKeys };
          } else {
            return { apiKeys: [...state.apiKeys, { providerId, key }] };
          }
        });
      },
      deleteApiKey: (providerId: string) => {
        set((state) => ({
          apiKeys: state.apiKeys.filter((key) => key.providerId !== providerId),
        }));
      },
      getApiKey: (providerId: string) => {
        const apiKey = get().apiKeys.find((key) => key.providerId === providerId);
        return apiKey ? apiKey.key : null;
      },
    }),
    {
      name: "api-keys-storage",
      storage: createJSONStorage(() => AsyncStorage),
    }
  )
);

export default useApiKeyStore;
