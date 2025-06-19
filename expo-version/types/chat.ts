export interface Message {
  id: string;
  role: "user" | "assistant" | "system";
  content: string;
  timestamp: number;
}

export interface Chat {
  id: string;
  title: string;
  messages: Message[];
  modelId: string;
  providerId: string;
  createdAt: number;
  updatedAt: number;
}

export interface ApiKey {
  providerId: string;
  key: string;
}
