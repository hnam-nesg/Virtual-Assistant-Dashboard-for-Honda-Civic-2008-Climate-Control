// Copyright (c) Daniel Gakwaya.
// SPDX-License-Identifier: MIT

function dbInit(){
    console.log(" Initializing database...")

    db = LocalStorage.openDatabaseSync("sqlitedemodb", "1.0", "SQLite Demo database", 100000);
    db.transaction( function(tx) {
        print('... create table')
        tx.executeSql('CREATE TABLE IF NOT EXISTS sqlitedemotable1(name TEXT, value TEXT)');
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
        var result = tx.executeSql('SELECT * from sqlitedemotable1 where name = "sqlitedemo"');

        //Prepare json object data from qml code
        var obj = {
            colorFan: textfanid.color, countFan: mousefanid.count, sourFan: mousefanid.sour,
            imageFan: imagefanid.source, imageFanc: imagefancid.source,

            colorRear: textrearid.color, countRear: mouserearid.count, sourRear: mouserearid.sour,
            imageRear: imagerearid.source, imageRearc: imagerearcid.source,

            colorRecir: textrecirid.color, countRecir: mouserecirid.count, sourRecir: mouserecirid.sour,
            imageRecir: imagerecirid.source, imageRecirc: imagerecircid.source,

            colorAc: textacid.color, countAc: mouseacid.count, sourAc: mouseacid.sour,
            imageAc: imageacid.source, imageAcc: imageaccid.source,

            opacity1: lightBeam1.opacity, opacity2: lightBeam2.opacity, opacity3: lightBeam3.opacity,
            count1: lightBeam1.count, count2: lightBeam2.count, count3: lightBeam3.count,

            fanLevel: fanctrlid.fanLevel, fanMemory: fanctrlid.fanmemory,
            imageAuto: imagefootid.source, colorAuto: textfootid.color, countAuto: mouseAutoid.count, opacityAuto: imagefootid.opacity,

            tempdv: seatdriverid.temp, temppass: seatpassid.temp, tempauto: window.temp_auto, Mode: window.mode, ModeRec: window.mode_rec, Lablelist: window.list, Autolist: window.list_auto


        }

        if ( result.rows.length ===1 ){
            //Update
            console.log("Updating database table...")
            result = tx.executeSql('UPDATE sqlitedemotable1 set value=? where name="sqlitedemo"',
                                    [JSON.stringify(obj)])
        }else{
            //Create entry
            console.log("Creating new database table entry")
            result = tx.executeSql('INSERT INTO sqlitedemotable1 VALUES (?,?)',
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
        var result = tx.executeSql('select * from sqlitedemotable1 where name="sqlitedemo"');

        if(result.rows.length === 1){
            //We have data that we can work  with

            // get the value column
            var value = result.rows[0].value;
            // convert to JS object
            var obj = JSON.parse(value)

            // apply to object
            textfanid.color= obj.colorFan
            imagefanid.source = obj.imageFan
            imagefancid.source = obj.imageFanc
            mousefanid.count = obj.countFan
            mousefanid.sour = obj.sourFan

            textrearid.color= obj.colorRear
            imagerearid.source = obj.imageRear
            imagerearcid.source = obj.imageRearc
            mouserearid.count = obj.countRear
            mouserearid.sour = obj.sourRear

            textrecirid.color = obj.colorRecir
            imagerecirid.source = obj.imageRecir
            imagerecircid.source = obj.imageRecirc
            mouserecirid.count = obj.countRecir
            mouserecirid.sour = obj.sourRecir

            textacid.color= obj.colorAc
            imageacid.source = obj.imageAc
            imageaccid.source = obj.imageAcc
            mouseacid.count = obj.countAc
            mouseacid.sour = obj.sourAc

            lightBeam1.opacity = obj.opacity1
            lightBeam2.opacity = obj.opacity2
            lightBeam3.opacity = obj.opacity3
            lightBeam1.count = obj.count1
            lightBeam2.count = obj.count2
            lightBeam3.count = obj.count3

            fanctrlid.fanLevel = obj.fanLevel
            fanctrlid.fanmemory = obj.fanMemory

            //imagefootid.source = obj.imageAuto
            imagefootid.source = obj.imageAuto
            //mouseAutoid.count = obj.countAuto
            mouseAutoid.count = obj.countAuto
            imagefootid.opacity = obj.opacityAuto
            textfootid.color = obj.colorAuto

            seatdriverid.temp = obj.tempdv
            seatpassid.temp = obj.temppass
            window.temp_auto = obj.tempauto

            window.mode = obj.Mode
            window.mode_rec = obj.ModeRec
            window.list = obj.Lablelist
            window.list_auto = obj.Autolist
        }

    });

}
