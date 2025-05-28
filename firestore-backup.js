import { initializeApp, applicationDefault, cert } from "firebase-admin/app";
import { getFirestore } from "firebase-admin/firestore";
import fs from 'fs'
import dotenv from 'dotenv';

dotenv.config();

//const serviceAccount = JSON.parse(fs.readFileSync('./serviceAccount.json'))
const serviceAccount = JSON.parse(process.env.SERVICE_ACCOUNT_JSON_BACKUP_DB);

initializeApp({
    credential: cert(serviceAccount)
});

const db = getFirestore();

async function backup(){
    const collections = await db.listCollections();
    const output = {};

    for(const collection of collections){
        const snapshot = await collection.get();
        output[collection.id] = [];

        snapshot.forEach(doc => {
            output[collection.id].push({id: doc.id, ...doc.data()});
        });
    }



    // Backticks statt einfachen Anführungszeichen !!
    const date = new Date().toISOString().split('T')[0];        // ergibt z.b. "2025-05-28"
    const filename = `firestore-backup-${date}.json`;
    fs.writeFileSync(filename, JSON.stringify(output, null, 2));

    console.log('Backup erfolgreich lokal gespeichert unter : ${filename}');
}

backup().catch(error => {
    console.error('Backup fehlgeschlagen: ', error);
});