#include "climatemodel.h"
#include <QDebug>

ClimateModel::ClimateModel(QObject *parent) : QObject(parent)
{
    // m_climate = new local::Climate("org.ivi","/Climate", QDBusConnection::sessionBus(), this);
    // if (m_climate->isValid()){
    //     qDebug() << "Climate dbus connect success";
    //     QObject::connect(m_climate,&local::Climate::dataChanged,this,&ClimateModel::dataChanged);
    // } else {
    //     qDebug() << "Climate dbus connect error";
    // }
    m_fanlevel = 0;
    m_tempdriver = 0;
    m_temppassenger = 0;
    m_automode = 0;
    m_drivermode = 0;
    m_passengermode = 0;
}

void ClimateModel::SetDriverTemperature(int temp)
{
    if (m_tempdriver != temp){
        qDebug() << "Temperture Driver: " << temp;
        m_tempdriver = temp;
        emit driverTempChanged(temp);
    }
}

void ClimateModel::SetPassengerTemperature(int temp)
{
    if (m_temppassenger != temp){
        qDebug() << "Temperture Passenger: " << temp;
        m_temppassenger = temp;
        emit passengerTempChanged(temp);
    }
}

void ClimateModel::SetFanLevel(int flv)
{
    if (m_fanlevel !=flv){
        qDebug() << "Fan level: " << flv ;
        m_fanlevel = flv;
        emit fanLevelChanged(flv);
    }
}

void ClimateModel::SetDriverWindMode(int mode)
{
    if (m_drivermode != mode){
        qDebug()<< "Driver mode: "<<mode;
        m_drivermode = mode;
        emit driverWindChanged(mode);
    }
}

void ClimateModel::SetPassengerWindMode(int mode)
{
    if (m_passengermode != mode){
        qDebug()<< "Passenger mode: "<<mode;
        m_passengermode = mode;
        emit passengerWindChanged(mode);
    }
}

void ClimateModel::SetAutoMode(int automode)
{
    if(m_automode != automode){
        qDebug() << "Mode: " << automode;
        m_automode = automode;
        emit autoChanged(automode);
    }
}

int ClimateModel::GetDriverTemperature()
{
    //return m_climate->getTemp_driver();
    return m_tempdriver;
}

int ClimateModel::GetPassengerTemperature()
{
    //return m_climate->getTemp_passenger();
    return m_temppassenger;
}

int ClimateModel::GetFanLevel()
{
    //return m_climate->getFan_speed();
    return m_fanlevel;
}

int ClimateModel::GetDriverWindMode()
{
    //return m_climate->getDriverWind_mode();
    return m_drivermode;
}

int ClimateModel::GetPassengerWindMode()
{
    //return m_climate->getPassengerWind_mode();
    return m_passengermode;
}

int ClimateModel::GetAutoMode()
{
    //return m_climate->getAuto_mode();
    return m_automode;
}

// int ClimateModel::GetSyncMode()
// {
//     return m_climate->getSync_mode();
// }
