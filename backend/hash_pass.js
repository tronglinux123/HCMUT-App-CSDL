const bcrypt = require('bcrypt');
const saltRounds = 10;
async function hashAdminPass() {
    const pass = '588413799';
    try {
        const hashPass = await bcrypt.hash(pass, saltRounds);
        console.log(hashPass);
    } catch (error) {
        console.error('Lỗi mã hóa', error);
    }
}

hashAdminPass();