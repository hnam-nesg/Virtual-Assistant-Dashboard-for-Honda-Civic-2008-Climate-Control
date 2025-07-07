// Copyright (c) Daniel Gakwaya.
// SPDX-License-Identifier: MIT

function dbInit(){
    console.log(" Initializing database...")

    db = LocalStorage.openDatabaseSync("sqlitedemodb", "1.0", "SQLite Demo database", 100000);
    db.transaction( function(tx) {
        print('... create table')
        tx.executeSql('CREATE TABLE IF NOT EXISTS sqlitedemotable(name TEXT, value TEXT)');
    });
}


function storeData(){
    console.log(" Storing data...")

    //Check if the database was ever created
    if (!db){
        return ;
    }

    db.transaction(function(tx){
        //Check if sqlitedemo entry is available in database table
        var result = tx.executeSql('SELECT * from sqlitedemotable where name = "sqlitedemo"');

        //Prepare json object data from qml code
        var obj = {
            fanLevel: fan_level.source, tempDriver: driver_temp.temp, tempPassenger: passenger_temp.temp,
            driverModeUp: driver_up.source, driverModeDown: driver_down.source,
            passengerModeUp: passenger_up.source, passengerModeDown: passenger_down.source, colorAuto: textAuto.color, State: root.state, stateTF: root.focus


        }

        if ( result.rows.length ===1 ){
            //Update
            console.log("Updating database table...")
            result = tx.executeSql('UPDATE sqlitedemotable set value=? where name="sqlitedemo"',
                                    [JSON.stringify(obj)])
        }else{
            //Create entry
            console.log("Creating new database table entry")
            result = tx.executeSql('INSERT INTO sqlitedemotable VALUES (?,?)',
                                    ['sqlitedemo', JSON.stringify(obj)])
        }

    });



}


function readData(){
    console.log(" Reading data...")

    if (!db){
        return ;
    }

    db.transaction( function(tx) {
        print('... Reading data from database')
        var result = tx.executeSql('select * from sqlitedemotable where name="sqlitedemo"');

        if(result.rows.length === 1){
            //We have data that we can work  with

            // get the value column
            var value = result.rows[0].value;
            // convert to JS object
            var obj = JSON.parse(value)
            // apply to object
            fan_level.source = obj.fanLevel
            driver_temp.temp = obj.tempDriver
            passenger_temp.temp = obj.tempPassenger
            driver_up.source = obj.driverModeUp
            driver_down.source = obj.driverModeDown
            passenger_up.source = obj.passengerModeUp
            passenger_down.source = obj.passengerModeDown
            textAuto.color = obj.colorAuto
            root.state = obj.State
            root.focus = obj.stateTF



        }

    });

}
