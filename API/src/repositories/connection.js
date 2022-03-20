import sql from 'mssql';

export class data {
    constructor(){
        this.dbSettings = {
            user: 'usersql',
            password: '1234',
            server: 'localhost',
            database: 'bases2_caso1',
            options: {
                encrypt: true,
                trustServerCertificate: true,
            }
        }
    }
    
    async getConnection() {
        try {
            const pool = await sql.connect(this.dbSettings);
            return pool;
        } catch (error) {
            console.error(error);
            }
    }
}