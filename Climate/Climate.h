#ifndef CLIMATE_H
#define CLIMATE_H
#include <QObject> 

class Climate: public QObject{
  Q_OBJECT
public:
  explicit Climate(QObject *parent = nullptr);
    int getTemp_driver();
    int getTemp_passenger();
    int getFan_speed();
    int getDriverWind_mode();
    int getPassengerWind_mode();
    int getAuto_mode();
    int getSync_mode();
};

#endif // CLIMATE_H
