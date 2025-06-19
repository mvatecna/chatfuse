import { Capacitor } from "@capacitor/core"
import { StatusBar, Style } from "@capacitor/status-bar"
import { SplashScreen } from "@capacitor/splash-screen"
import { Keyboard } from "@capacitor/keyboard"
import { Haptics, ImpactStyle } from "@capacitor/haptics"
import { Share } from "@capacitor/share"
import { App } from "@capacitor/app"
import { Device } from "@capacitor/device"

export class CapacitorService {
  static isNative = Capacitor.isNativePlatform()
  static platform = Capacitor.getPlatform()

  static async initialize() {
    if (!this.isNative) return

    try {
      // Hide splash screen
      await SplashScreen.hide()

      // Configure status bar
      await StatusBar.setStyle({ style: Style.Default })
      await StatusBar.setBackgroundColor({ color: "#ffffff" })

      // Configure keyboard
      Keyboard.addListener("keyboardWillShow", () => {
        document.body.classList.add("keyboard-open")
      })

      Keyboard.addListener("keyboardWillHide", () => {
        document.body.classList.remove("keyboard-open")
      })

      // Handle app state changes
      App.addListener("appStateChange", ({ isActive }) => {
        console.log("App state changed. Is active?", isActive)
      })

      // Handle back button on Android
      App.addListener("backButton", ({ canGoBack }) => {
        if (!canGoBack) {
          App.exitApp()
        } else {
          window.history.back()
        }
      })
    } catch (error) {
      console.error("Error initializing Capacitor:", error)
    }
  }

  static async setStatusBarStyle(isDark: boolean) {
    if (!this.isNative) return

    try {
      await StatusBar.setStyle({
        style: isDark ? Style.Dark : Style.Light,
      })
      await StatusBar.setBackgroundColor({
        color: isDark ? "#111827" : "#ffffff",
      })
    } catch (error) {
      console.error("Error setting status bar style:", error)
    }
  }

  static async hapticFeedback(style: ImpactStyle = ImpactStyle.Light) {
    if (!this.isNative) return

    try {
      await Haptics.impact({ style })
    } catch (error) {
      console.error("Error with haptic feedback:", error)
    }
  }

  static async shareText(text: string, title?: string) {
    if (!this.isNative) {
      // Fallback to Web Share API
      if (navigator.share) {
        try {
          await navigator.share({ text, title })
          return true
        } catch (error) {
          console.error("Error sharing:", error)
        }
      }
      return false
    }

    try {
      await Share.share({ text, title })
      return true
    } catch (error) {
      console.error("Error sharing:", error)
      return false
    }
  }

  static async getDeviceInfo() {
    if (!this.isNative) return null

    try {
      const info = await Device.getInfo()
      return info
    } catch (error) {
      console.error("Error getting device info:", error)
      return null
    }
  }

  static async closeKeyboard() {
    if (!this.isNative) return

    try {
      await Keyboard.hide()
    } catch (error) {
      console.error("Error hiding keyboard:", error)
    }
  }
}
