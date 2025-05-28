import { initializeApp, cert } from "firebase-admin/app";
import { getFirestore } from "firebase-admin/firestore";
import { getStorage } from "firebase-admin/storage";
import fs from 'fs'

const serviceAccount = JSON.parse(fs.readFileSync('./serviceAccount.json'))
//const serviceAccount = JSON.parse(process.env.SERVICE_ACCOUNT_JSON_BACKUP_DB);

initializeApp({
    credential: cert(serviceAccount),
    // Backticks statt einfachen Anführungszeichen !!
    storageBucket: `${serviceAccount.project_id}.appspot.com`
});

const db = getFirestore();
const storageBucket = getStorage().bucket();

async function backup(){
    const collections = await db.listCollections();
    const output = {};

    for(const collection of collections){
        const snapshot = await collection.get();
        output[collection.id] = snapshot.docs.map(doc => ({
            id: doc.id,
            data: doc.data
        }));
    }

    // Backticks statt einfachen Anführungszeichen !!
    const filename = `firestore-backup-${new Date().toISOString()}.json`;
    const file = storageBucket.file(filename);
    await file.save(JSON.stringify(output, null, 2));

    console.log('Backup erfolgreich gespeichert in Cloud Storage: ${filename}');
}

backup();