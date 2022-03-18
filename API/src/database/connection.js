import sql from 'mssql';

const dbSettings = {
    user: 'usersql',
    password: '1234',
    server: 'localhost',
    database: 'bases2_caso1',
    options: {
        encrypt: true,
        trustServerCertificate: true,
    },
};

export async function getConnection() {
    try {
        const pool = await sql.connect(dbSettings);
        return pool;
    } catch (error) {
        console.error(error);
    }
};