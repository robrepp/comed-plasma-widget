import QtQuick
import org.kde.plasma.plasmoid

PlasmoidItem {
    // Minimal representation
    compactRepresentation: Text {
        text: "2.6¢"
        font.pixelSize: 12
    }

    fullRepresentation: Text {
        text: "ComEd Price Monitor\n(Hello World Test)"
        font.pixelSize: 20
        anchors.centerIn: parent
    }
    
    preferredRepresentation: fullRepresentation
}
