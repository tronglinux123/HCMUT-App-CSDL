import React, { Children, useState, useEffect } from "react";
import { Outlet } from "react-router-dom";
import axios from 'axios';

const MentorApplyRoute = ({ children }) => {
    const [applicationStatus, setApplicationStatus] = useState(''); 
    const storage_email = localStorage.getItem('emailCurrent'); 
    const BACKEND_URL = 'http://localhost:5000';
    const userRole =  localStorage.getItem('userRole');
    if (!userRole || userRole !== 'mentee'){
        const errorStyle = {
            height: '100vh', 
            display: 'flex', 
            flexDirection: 'column',
            justifyContent: 'center', 
            alignItems: 'center', 
            backgroundColor: '#f8d7da', 
            color: '#721c24',           
            padding: '2rem',
            textAlign: 'center'
        };

        return (
            <div style={errorStyle}> 
                <h1 style={{ fontSize: '2rem', marginBottom: '1rem' }}>
                    🚫 Lỗi Truy Cập
                </h1>
                <p style={{ fontSize: '1.2rem', fontWeight: 'bold' }}>
                    Chỉ mentee được phép đăng ký làm mentor.
                </p>
                <p>
                    Vui lòng đăng nhập bằng tài khoản mentee hoặc liên hệ admin.
                </p>
            </div>
        );
    }   
    
    useEffect(() => {
        const checkApplication = async() => {
            try {
                const response = await axios.post(`${BACKEND_URL}/api/ApplicationCheck`,{
                    email: storage_email
                });
                const job = response.data.user.job;
                const specialized = response.data.user.specialized;
                const yearstudy = response.data.user.yearstudy;
                const gpa = response.data.user.gpa;
                const status = response.data.user.status;
                setApplicationStatus(status); 
            } catch (error) {
                if (error.response && error.response.status === 404) {
                    console.error('Chưa có đơn', error.response?.data?.message || error.message);
                    setApplicationStatus('no_fault');
                } else {
                    console.error('Lỗi hệ thống khi kiểm tra đơn ứng tuyển:', error.response?.data?.message || error.message);
                }
            }
       };
       if (userRole ==='mentee'){
        checkApplication();
       }
    }, [userRole, storage_email, BACKEND_URL]);

    if (applicationStatus === 'pending') {
        const successStyle = {
            height: '100vh', 
            display: 'flex', 
            flexDirection: 'column',
            justifyContent: 'center', 
            alignItems: 'center', 
            backgroundImage: 'linear-gradient(to bottom, hsl(212, 100%, 50%), #c0ddff)',
            color: '#ffffffff',           
            padding: '2rem',
            textAlign: 'center'
        };

        return (
            <div style={successStyle}> 
                <h1 style={{ fontSize: '2rem', marginBottom: '1rem' }}>
                    ⏳ Đơn Đã Được Nộp Thành Công
                </h1>
                <p style={{ fontSize: '1.2rem', fontWeight: 'bold' }}>
                    Đơn đăng ký Mentor của bạn đang trong quá trình xét duyệt. Vui lòng đợi thông báo từ Admin.
                </p>
            </div>
        );
    }
    
    if (applicationStatus === 'no_fault'){
        return children ? children : <Outlet />;
    }
    
}
export default MentorApplyRoute;