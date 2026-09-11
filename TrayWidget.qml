import QtQuick 2.15
import Quickshell.Services.SystemTray // Импортируем системный сервис Quickshell

Item {
    id: root
    property int margins: 4

    // Основной фон плагина (по стандартам JES)
    Rectangle {
        anchors.fill: parent
        opacity: 0.85
        radius: mainRad
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: col.background3 }
            GradientStop { position: 0.05; color: col.background2 }
            GradientStop { position: 0.3; color: col.background1 }
            GradientStop { position: 0.7; color: col.background1 }
            GradientStop { position: 0.95; color: col.background2 }
            GradientStop { position: 1.0; color: col.background3 }
        }
    }

    // Горизонтальный список для 1 строки
    ListView {
        anchors.fill: parent
        anchors.margins: root.margins
        orientation: ListView.Horizontal
        spacing: 6
        
        // Заимствуем принцип: берем данные напрямую из SystemTray
        model: SystemTray.items.values
        
        delegate: Item {
            id: button
            width: height
            height: parent.height
            property bool hovered: false

            // Фон кнопки приложения в трее
            Rectangle {
                anchors.fill: parent
                radius: mainRad - root.margins
                opacity: 0.65
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0; color: col.backgroundAlt2 }
                    GradientStop { position: 0.275; color: col.backgroundAlt1 }
                    GradientStop { position: 0.725; color: col.backgroundAlt1 }
                    GradientStop { position: 1.0; color: col.backgroundAlt2 }
                }
            }

            // Эффект наведения
            Rectangle {
                anchors.fill: parent
                anchors.margins: 2
                radius: mainRad - 2 - root.margins
                color: button.hovered ? col.accent : "transparent"
                Behavior on color { ColorAnimation { duration: 200 } }
            }

            // Отрисовка самой иконки из сервиса SystemTray
            Image {
                anchors.centerIn: parent
                width: parent.width * 0.6
                height: parent.height * 0.6
                source: modelData.icon // Получаем иконку из объекта трея
                fillMode: Image.PreserveAspectFit
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: button.hovered = true
                onExited: button.hovered = false
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: (mouse) => {
                    if (mouse.button === Qt.LeftButton) {
                        modelData.activate() // Стандартное левое нажатие
                    } else if (mouse.button === Qt.RightButton) {
                        modelData.contextMenu() // Вызов контекстного меню
                    }
                }
            }
        }
    }
}
