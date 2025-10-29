const pool = require('./db');

exports.applicate = async (req, res) => {
    const { apply_email, aplly_job, specialized, yearstudy, gpa } = req.body;
    if(!apply_email || !aplly_job || !specialized || !yearstudy || !gpa){
        return res.status(400).json({ message: "Vui lòng điền đủ"});
    }
    try {
        const SQL = 'INSERT INTO mentor_applications (apply_email, aplly_job, specialized, yearstudy, gpa) VALUES (?,?,?,?,?)';
        const [result] = await pool.execute(
            SQL,
            [apply_email, aplly_job, specialized, yearstudy, gpa]
        );
        return res.status(201).json({
            message: 'Đăng ký thành công, đang chờ xét duyệt từ Admin',
            userId: result.insertId
        })
    } catch (err) {
        console.error('Lỗi khi đăng ký',err);
        return res.status(500).json({ message: 'Lỗi hệ thống khi đăng ký'});
    }
}

exports.check = async (req, res) => {
    try {
        const { email } = req.body;
        const [rows] = await pool.execute(
            'SELECT apply_email, aplly_job, specialized, yearstudy, gpa, status FROM mentor_applications WHERE apply_email = ?',
            [email]
        );
        if (rows.length===0){
            return res.status(404).json({ message: 'Không tìm thấy đơn ứng tuyển.' });
        }
        const user = rows[0];
        return res.status(200).json({
            user: {
                email: user.apply_email,
                job: user.apply_job,
                specialized: user.specialized,
                yearstudy: user.yearstudy,
                gpa: user.gpa,
                status: user.status
            }
        }); 
    } catch (error) {
        console.error('Lỗi hệ thống khi kiểm tra đơn ứng tuyển:', error);
        return res.status(500).json({ message: 'Lỗi hệ thống Server.' });
    }
    
}

exports.select = async (req, res) => {
    try {
        console.log('1');
        const [rows] = await pool.execute(
            'SELECT * FROM mentor_applications ORDER BY created_at DESC',
        );
        if (rows.length===0){
            return res.status(404).json({ message: 'Không tìm thấy đơn ứng tuyển.' });
        }
        return res.status(200).json({
            applications: rows
        });
    } catch (error) {
        console.error('Lỗi hệ thống khi kiểm tra đơn ứng tuyển:', error);
        return res.status(500).json({ message: 'Lỗi hệ thống Server.' });
    }
    
}