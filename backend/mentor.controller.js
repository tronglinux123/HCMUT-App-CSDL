const pool = require('./db');

exports.applicate = async (req, res) => {
    const { name, apply_email, aplly_job, specialized, yearstudy, gpa } = req.body;
    if(!name || !apply_email || !aplly_job || !specialized || !yearstudy || !gpa){
        return res.status(400).json({ message: "Vui lòng điền đủ"});
    }
    try {
        const [existing] = await pool.execute(
            'SELECT apply_email, status FROM mentor_applications WHERE apply_email = ?',
            [apply_email]
        );
        const exist = existing[0];
        if (existing.length === 0){
            const SQL = 'INSERT INTO mentor_applications (name, apply_email, aplly_job, specialized, yearstudy, gpa) VALUES (?,?,?,?,?,?)';
            const [result] = await pool.execute(
                SQL,
                [name, apply_email, aplly_job, specialized, yearstudy, gpa]
            );
            return res.status(201).json({
                message: 'Đăng ký thành công, đang chờ xét duyệt từ Admin',
                userId: result.insertId
            })
        } 
        if (exist.status === 'rejected'){
            const UPDATE_SQL = `
                UPDATE mentor_applications 
                SET 
                    aplly_job = ?, 
                    specialized = ?, 
                    yearstudy = ?, 
                    gpa = ?,
                    status = 'pending',
                    created_at = NOW()
                WHERE apply_email = ?`; 

            await pool.execute(
                UPDATE_SQL,
                [aplly_job, specialized, yearstudy, gpa, apply_email]
            );
            return res.status(200).json({
                message: 'Đăng ký lại thành công, đang chờ xét duyệt từ Admin'
            });
        }
        return res.status(400).json({
            message: 'Email này đã được sử dụng cho một đơn đang xét duyệt hoặc đã được duyệt'
        });
    } catch (err) {
        console.error('Lỗi khi đăng ký',err);
        return res.status(500).json({ message: 'Lỗi hệ thống khi đăng ký'});
    }
}

exports.check = async (req, res) => {
    try {
        const { email } = req.body;
        const [rows] = await pool.execute(
            'SELECT apply_email, status FROM mentor_applications WHERE apply_email = ?',
            [email]
        );
        if (rows.length===0){
            return res.status(404).json({ message: 'Không tìm thấy đơn ứng tuyển.' });
        }
        const user = rows[0];
        return res.status(200).json({
            user: {
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

        const [rows] = await pool.execute(
            'SELECT * FROM mentor_applications WHERE status = \'pending\' ORDER BY created_at ASC',
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

exports.delete = async (req, res) => {
    try {
        const { id } = req.body;
        const [rows] = await pool.execute(
            'UPDATE mentor_applications SET status = \'rejected\' WHERE id = ?',
            [id]
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

exports.access = async (req, res) => {
    try {
        const { id } = req.body;
        const [rows] = await pool.execute(
            'UPDATE mentor_applications SET status = \'approved\' WHERE id = ?',
            [id]
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