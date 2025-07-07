#ifndef CLIMATEMODEL_H
#define CLIMATEMODEL_H

#include <QObject>
//#include <QDBusConnection>

class ClimateModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int driver_temp READ GetDriverTemperature WRITE SetDriverTemperature NOTIFY driverTempChanged)
    Q_PROPERTY(int passenger_temp READ GetPassengerTemperature WRITE SetPassengerTemperature NOTIFY passengerTempChanged)
    Q_PROPERTY(int driver_wind_mode READ GetDriverWindMode WRITE SetDriverWindMode NOTIFY driverWindChanged)
    Q_PROPERTY(int passenger_wind_mode READ GetPassengerWindMode WRITE SetPassengerWindMode NOTIFY passengerWindChanged)
    Q_PROPERTY(int fan_level READ GetFanLevel WRITE SetFanLevel  NOTIFY fanLevelChanged)
    Q_PROPERTY(int auto_mode READ GetAutoMode WRITE SetAutoMode NOTIFY autoChanged)
    // Q_PROPERTY(int sync_mode READ GetSyncMode WRITE SetSyncMode NOTIFY dataChanged)
public:
    explicit ClimateModel(QObject *parent = nullptr);
    int m_fanlevel;
    int m_tempdriver;
    int m_temppassenger;
    int m_automode;
    int m_drivermode;
    int m_passengermode;

private:
    void SetDriverTemperature(int temp);
    void SetPassengerTemperature(int temp);
    void SetFanLevel(int flv);
    void SetDriverWindMode(int mode);
    void SetPassengerWindMode(int mode);
    void SetAutoMode(int automode);
    // void SetSyncMode();

    int GetDriverTemperature();
    int GetPassengerTemperature();
    int GetFanLevel();
    int GetDriverWindMode();
    int GetPassengerWindMode();
    int GetAutoMode();
    // int GetSyncMode();
signals:
    void driverTempChanged(int temp);
    void passengerTempChanged(int temp);
    void driverWindChanged(int mode);
    void passengerWindChanged (int mode);
    void fanLevelChanged(int flv);
    void autoChanged(int mode);
public slots:
};

#endif // CLIMATEMODEL_H
