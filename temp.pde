#include "OneWire.h"
#include "fArduino.h"
#include "DS18B20TemperatureSensor.h"

#define ONE_WIRE_BUS 2

OneWire                  _oneWire(ONE_WIRE_BUS);
DS18B20TemperatureSensor _DS18B20(&_oneWire);
TimeOut                  _oneSecondTimeOut(1000);

void setup() {

    Board.InitializeComputerCommunication(9600, "Initializing...");
    Board.TraceHeader("Temperature Sensor DS18B20");
    Board.Trace(Board.Format("Sensor ID:%d, Name:%s",
                _DS18B20.GetSensorId(), _DS18B20.GetSensorName()));

    Board.Trace(Board.Format("Sensor Ids:%s", 
                _DS18B20.GetSensorUniqueIdsOn1Wire().c_str()));
    Board.Trace("Ready...");
}

void loop() {

    static double previousCelsius;

    if (_oneSecondTimeOut.IsTimeOut()) {

        double celsius = _DS18B20.GetTemperature();

        if (previousCelsius != celsius || _oneSecondTimeOut.EveryCalls(10)) {
            
            double fahrenheit = _DS18B20.CelsiusToFahrenheit(celsius);
            Board.Trace(Board.Format("[%s, mem:%d] %fC - %fF",  
                        Board.GetTime(), Board.GetFreeMemory(), celsius, fahrenheit));
            previousCelsius = celsius;
        }
    }
}