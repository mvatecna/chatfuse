import FontAwesome from "@expo/vector-icons/FontAwesome";
import { useFonts } from "expo-font";
import { Stack } from "expo-router";
import * as SplashScreen from "expo-splash-screen";
import { useEffect } from "react";
import { StatusBar } from "expo-status-bar";
import useThemeStore from "@/store/useThemeStore";

export const unstable_settings = {
  initialRouteName: "(tabs)",
};

// Prevent the splash screen from auto-hiding before asset loading is complete.
SplashScreen.preventAutoHideAsync();

export default function RootLayout() {
  const [loaded, error] = useFonts({
    ...FontAwesome.font,
  });

  useEffect(() => {
    if (error) {
      console.error(error);
      throw error;
    }
  }, [error]);

  useEffect(() => {
    if (loaded) {
      SplashScreen.hideAsync();
    }
  }, [loaded]);

  if (!loaded) {
    return null;
  }

  return <RootLayoutNav />;
}

function RootLayoutNav() {
  const { isDarkMode } = useThemeStore();

  return (
    <>
      <StatusBar style={isDarkMode ? "light" : "dark"} />
      <Stack
        screenOptions={{
          headerBackTitle: "Back",
          headerStyle: {
            backgroundColor: isDarkMode ? "#121212" : "#FFFFFF",
          },
          headerTintColor: isDarkMode ? "#FFFFFF" : "#1A1A1A",
          contentStyle: {
            backgroundColor: isDarkMode ? "#121212" : "#FFFFFF",
          },
        }}
      >
        <Stack.Screen name="(tabs)" options={{ headerShown: false }} />
        <Stack.Screen
          name="chat/[id]"
          options={{
            title: "Chat",
            headerBackTitle: "Chats",
          }}
        />
        <Stack.Screen
          name="new-chat"
          options={{
            title: "New Chat",
            presentation: "modal",
          }}
        />
      </Stack>
    </>
  );
}
