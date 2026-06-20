// ╔══════════════════════════════════════════════════════════════╗
// ║  QUICKSHELL — Scaffolding mínimo funcional                   ║
// ║  Repo: github.com/sifaconer/Dotfiles                         ║
// ║                                                              ║
// ║  Reemplaza: waybar (bar), mako (notificaciones)              ║
// ║  Pendiente (TODO): launcher, power menu, clipboard picker    ║
// ║                                                              ║
// ║  CÓMO EXTENDER:                                             ║
// ║    Docs:   https://quickshell.outfoxxed.me/docs/v0.3.0       ║
// ║    Tipos:  PanelWindow, SystemTray, Networking, Pipewire,    ║
// ║            UPower, Mpris, Hyprland (workspaces)              ║
// ║    LSP:    crear .qmlls.ini vacío junto a este archivo       ║
// ║            (gitignorearlo — lo genera quickshell)            ║
// ║                                                              ║
// ║  Live-reload: guardá este archivo y quickshell recarga solo  ║
// ║  Docs config: https://quickshell.outfoxxed.me/docs/v0.3.0/guide/introduction ║
// ╚══════════════════════════════════════════════════════════════╝

import Quickshell
import Quickshell.Services.Notifications
import QtQuick

ShellRoot {
    // ── Notification daemon (reemplaza mako) ──────────────────────
    // Captura notificaciones del bus freedesktop. La UI de popups
    // es el próximo paso: usar un Repeater sobre NotificationServer
    // con PopupWindow por cada notificación activa.
    //
    // Docs: /docs/v0.3.0/types/Quickshell.Services.Notifications/NotificationServer
    NotificationServer {}

    // ── Bar por monitor ──────────────────────────────────────────
    // Se crea/destruye automáticamente al conectar/desconectar pantallas.
    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 32
            color: "#1e1e2e"  // TODO: cambiar al diseñar tu tema

            // ── Reloj (centro) ────────────────────────────────────
            // SystemClock es nativo de quickshell (sin spawn de procesos).
            Text {
                anchors.centerIn: parent
                color: "#cdd6f4"
                font.family: "JetBrains Mono"
                font.pixelSize: 14

                // Binding reactivo: se actualiza solo cuando clock.date cambia
                text: Qt.formatDateTime(clock.date, "ddd d MMM  hh:mm:ss")

                SystemClock {
                    id: clock
                    precision: SystemClock.Seconds
                }
            }

            // ── TODO: workspaces (Quickshell.Hyprland.Hyprland) ───
            // ── TODO: system tray (Quickshell.Services.SystemTray) ─
            // ── TODO: audio (Quickshell.Services.Pipewire) ─────────
            // ── TODO: red/batería (Quickshell.Networking / UPower) ─
        }
    }
}
