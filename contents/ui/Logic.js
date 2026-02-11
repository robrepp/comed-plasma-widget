.pragma library

function fetchPrice(callback) {
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status === 200) {
                try {
                    var readings = JSON.parse(xhr.responseText);
                    var processed = processReadings(readings);
                    callback(processed);
                } catch (e) {
                    console.error("JSON Parse Error: " + e);
                    callback(null);
                }
            } else {
                console.error("API Error: " + xhr.status);
                callback(null);
            }
        }
    }
    xhr.open("GET", "https://hourlypricing.comed.com/rrtp/ServletFeed?type=5minutefeed");
    xhr.send();
}

function processReadings(readings) {
    if (!readings || readings.length === 0) return null;

    // Helper: string to float
    var parsePrice = function(r) { return parseFloat(r.price) || 0.0; };

    // 1. Current Price (for trend calculation)
    var currentPrice = parsePrice(readings[0]);

    // 2. Hourly Average (prefix 12)
    var hourReadings = readings.slice(0, 12);
    var sum = 0;
    for (var i = 0; i < hourReadings.length; i++) {
        sum += parsePrice(hourReadings[i]);
    }
    var averagePrice = sum / hourReadings.length;

    // 3. Trend (compare newest vs 4th reading ~20mins ago)
    var trend = "→";
    if (readings.length >= 4) {
        var newest = parsePrice(readings[0]);
        var oldest = parsePrice(readings[3]); 
        var diff = newest - oldest;
        if (diff > 0.5) trend = "↗";
        else if (diff < -0.5) trend = "↘";
    }

    // 4. Tier (Low/Medium/High based on AVERAGE)
    var tier = "Low";
    // Colors matching Swift WidgetTheme
    // Green: #43bf55, Orange: #d38240, Red: #c50033
    var bgColor = "#43bf55"; 
    
    if (averagePrice >= 8 && averagePrice < 14) {
        tier = "Medium";
        bgColor = "#d38240";
    } else if (averagePrice >= 14) {
        tier = "High";
        bgColor = "#c50033";
    }

    // 5. History Data (reversed for bar graph: oldest -> newest)
    var history = hourReadings.map(function(r) {
        return {
            "price": parsePrice(r),
            "millis": r.millisUTC
        };
    }).reverse();

    return {
        "price": averagePrice.toFixed(1),
        "trend": trend,
        "tier": tier,
        "bgColor": bgColor,
        "history": history,
        // Short time format (e.g. 1:45 PM)
        "timestamp": new Date().toLocaleTimeString([], {hour: 'numeric', minute:'2-digit'})
    };
}
