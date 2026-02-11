import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import "Logic.js" as Logic

PlasmoidItem {
    id: root
    
    // Properties to hold data
    property string priceStr: "--"
    property string trendStr: ""
    property string tierStr: "Loading..."
    property string timestampStr: ""
    property var historyData: []
    property color tierColor: "#43bf55" // Default green

    // Timer to fetch data every 5 minutes
    Timer {
        interval: 300000 // 5 minutes
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            Logic.fetchPrice(function(data) {
                if (data) {
                    root.priceStr = data.price
                    root.trendStr = data.trend
                    root.tierStr = data.tier
                    root.tierColor = data.bgColor
                    root.timestampStr = data.timestamp
                    root.historyData = data.history
                }
            })
        }
    }

    // Size hints to mimic "Medium" widget aspect ratio (~2:1)
    preferredRepresentation: fullRepresentation
    
    fullRepresentation: Item {
        Layout.preferredWidth: 300
        Layout.preferredHeight: 160 // Increased height slightly to prevent clipping
        Layout.minimumWidth: 200
        Layout.minimumHeight: 120
        
        Rectangle {
            anchors.fill: parent
            color: root.tierColor
            radius: 16 // iOS-like rounded corners
            
            // Main Content Container
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 12 // Reduced margins to give content more room
                spacing: 8 // Reduced spacing to pull elements together
                
                // Top Row: Price Info (Left) vs Tier/Time (Right)
                RowLayout {
                    Layout.fillWidth: true
                    
                    // LEFT: Label + Price + Trend
                    ColumnLayout {
                        spacing: 0
                        
                        Text {
                            text: "ComEd Price"
                            font.pixelSize: 12
                            font.weight: Font.Bold
                            color: "white"
                            opacity: 0.8
                        }
                        
                        RowLayout {
                            spacing: 4
                            Text {
                                text: root.priceStr
                                font.pixelSize: 42
                                font.weight: Font.Bold
                                color: "white"
                            }
                            Text {
                                text: "¢"
                                font.pixelSize: 20
                                font.weight: Font.Bold
                                color: "white"
                                Layout.alignment: Qt.AlignBaseline
                            }
                            Text {
                                text: root.trendStr
                                font.pixelSize: 24
                                color: "white"
                                Layout.alignment: Qt.AlignBaseline
                            }
                        }
                        
                        Text {
                            text: "Hourly Avg"
                            font.pixelSize: 11
                            color: "white"
                            opacity: 0.7
                        }
                    }
                    
                    Item { Layout.fillWidth: true } // Spacer
                    
                    // RIGHT: Tier Pill + Time
                    ColumnLayout {
                        Layout.alignment: Qt.AlignTop | Qt.AlignRight
                        spacing: 4
                        
                        Rectangle {
                            color: "black"
                            opacity: 0.2
                            radius: 12
                            Layout.preferredWidth: tierLabel.implicitWidth + 20
                            Layout.preferredHeight: tierLabel.implicitHeight + 10
                            
                            Text {
                                id: tierLabel
                                anchors.centerIn: parent
                                text: root.tierStr
                                font.pixelSize: 12
                                font.weight: Font.Bold
                                color: "white"
                            }
                        }
                        
                        Item { Layout.fillHeight: true } // Spacer
                        
                        Text {
                            text: root.timestampStr
                            font.pixelSize: 11
                            color: "white"
                            opacity: 0.7
                            Layout.alignment: Qt.AlignRight
                        }
                    }
                }
                
                // Bottom Row: Bar Chart
                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 45 // Fixed height for chart area
                    spacing: 4
                    Layout.alignment: Qt.AlignBottom
                    
                    Repeater {
                        model: root.historyData
                        
                        delegate: ColumnLayout {
                            spacing: 2
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignBottom
                            
                            // Bar (Top)
                            Rectangle {
                                property double maxPrice: 20.0
                                property double minHeight: 4.0
                                property double maxHeight: 28.0 
                                
                                Layout.fillWidth: true
                                Layout.preferredHeight: {
                                    var val = modelData.price
                                    var norm = Math.min(val / maxPrice, 1.0)
                                    return minHeight + (maxHeight - minHeight) * norm
                                }
                                
                                color: "black"
                                opacity: 0.3
                                radius: 2
                            }

                            // Bar Label (Bottom)
                            Text {
                                text: modelData.price.toFixed(1)
                                font.pixelSize: 9
                                font.weight: Font.Bold
                                color: "white"
                                opacity: 0.8
                                Layout.alignment: Qt.AlignCenter
                            }
                        }
                    }
                }
            }
        }
    }
}
