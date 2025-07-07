// Copyright (c) Daniel Gakwaya.
// SPDX-License-Identifier: MIT

function dbInit(){
    console.log(" Initializing database...")

    db = LocalStorage.openDatabaseSync("sqlitedemodb", "1.0", "SQLite Demo database", 100000);
    db.transaction( function(tx) {
        print('... create table')
        tx.executeSql('CREATE TABLE IF NOT EXISTS sqlitedemotableMedia(name TEXT, value TEXT)');
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
        var result = tx.executeSql('SELECT * from sqlitedemotableMedia where name = "sqlitedemo"');

        //Prepare json object data from qml code
        var obj = {
            playerSource: player.source, currentIndex: mediaPlaylist.currentIndex
        }

        if ( result.rows.length ===1 ){
            //Update
            console.log("Updating database table...")
            result = tx.executeSql('UPDATE sqlitedemotableMedia set value=? where name="sqlitedemo"',
                                    [JSON.stringify(obj)])
        }else{
            //Create entry
            console.log("Creating new database table entry")
            result = tx.executeSql('INSERT INTO sqlitedemotableMedia VALUES (?,?)',
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
        var result = tx.executeSql('select * from sqlitedemotableMedia where name="sqlitedemo"');

        if(result.rows.length === 1){
            //We have data that we can work  with

            // get the value column
            var value = result.rows[0].value;
            // convert to JS object
            var obj = JSON.parse(value)

            // apply to object
            player.source = obj.playerSource
            mediaPlaylist.currentIndex = obj.currentIndex
        }

    });

}
