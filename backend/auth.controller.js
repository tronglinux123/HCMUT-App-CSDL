const pool = require('./db');
const bcrypt = require('bcrypt');
const saltRounds =10;

// đăng ký
exports.register = async (req, res) => {
    const { name, email_dk, pass_dk, phone } = req.body;
    if (!name || !email_dk || !pass_dk || !phone){
        return res.status(400).json({ message: "Vui lòng điền đủ"});
    }
    try {
        const hashedPassword = await bcrypt.hash(pass_dk, saltRounds);
        const SQL = 'INSERT INTO users (name, email, password_hash, phone) VALUES (?,?,?,?)';
        const [result] = await pool.execute(
            SQL,
            [name,email_dk,hashedPassword,phone]
        );
        return res.status(201).json({
            message: 'Đăng ký tài khoản thành công',
            userId: result.insertId
        })
    } catch (err) {
        console.error('Lỗi khi đăng ký',err);
        if (err.code === 'ER_DUP_ENTRY') { 
            return res.status(409).json({ message: 'Email này đã được sử dụng. Vui lòng thử email khác.' });
        }
        return res.status(500).json({ message: 'Lỗi hệ thống khi đăng ký.' });
    }   
};
// login
exports.login = async (req, res) => {
    const { email,password } = req.body;
    if (!email || !password) {
        return res.status(400).json({message: 'Vui lòng nhập Email và Mật khẩu.'});
    }
    try {
        const [rows] = await pool.execute(
            'SELECT id, name, email, password_hash, role FROM users WHERE email = ?',
            [email]
        );
        if (rows.length === 0) {
            return res.status(401).json({ message: 'Email hoặc mật khẩu không đúng'});
        }
        const user = rows[0];
        console.log("Database user role:", user.role);
        const isMatch = await bcrypt.compare(password, user.password_hash);
        if (!isMatch) {
            return res.status(401).json({ message: 'Email hoặc mật khẩu không đúng'});
        }
        return res.status(200).json({
            message: 'Đăng nhập thành công',
            user: {
                id: user.id,
                name: user.name,
                email: user.email,
                role: user.role
            }
        });
    } catch (err) {
        console.error('Lỗi khi đăng nhập:',err);
        return res.status(500).json({ message: 'Lỗi hệ thông đăng nhập'});
    }
};