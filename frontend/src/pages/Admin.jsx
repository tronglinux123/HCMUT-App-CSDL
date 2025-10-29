import './Admin.css';
import axios from 'axios';
import React, { use, useState, useEffect } from 'react';

function Admin() {
  const BACKEND_URL = 'http://localhost:5000';
  const userRole =  localStorage.getItem('userRole');
  const [appliCations, setAppliCations] = useState([]);
  useEffect(() => {
    const menteeApplyForm = async () => {
      try {
        const response = await axios.get(`${BACKEND_URL}/api/ApplicationCheckByAdmin`);
        const applications = response.data.applications;
        console.log(applications);
        setAppliCations(applications);
        
      } catch (error) {
        if (error.response && error.response.status === 404) {
            console.error('Error:', error.response?.data?.message || error.message);
        } else {                                                                      
            console.error('Lỗi hệ thống khi kiểm tra đơn ứng tuyển:', error.response?.data?.message || error.message);
        } 
      }
    };
    if (userRole === 'admin'){
      menteeApplyForm();
    }
    
  },[BACKEND_URL]);
//   aplly_job: "giangvien"
// ​​
// apply_email: "trong@gmail.com"
// ​​
// created_at: "2025-10-29T03:32:00.000Z"
// ​​
// gpa: "3.00"
// ​​
// id: 1
// ​​
// specialized: "khmt"
// ​​
// status: "pending"
// ​​
// yearstudy: "none"
  return (     
    <div className='admin'>                                                                                                                                                    
        <div className="ApplicationCheckByAdmin">
            {appliCations.map((apply) => (
              <div className='ApplyCard'>
                <div className='ben1'>
                  <h1>ngu</h1>
                  <h1>Chức danh: {apply.aplly_job}</h1>
                  <h1>Sinh viên năm: {apply.yearstudy}</h1>
                  <h1>{apply.status}</h1>
                </div>
                <div className='ben2'>
                  <h1>email: {apply.apply_email}</h1>
                  <h1>Khoa: {apply.specialized}</h1>
                  <h1>Gpa: {apply.gpa}</h1>
                </div>
                
                
                
              </div>
            ))}
        </div>
        <div className="ApplyForMentor">
            <h1>ahihiihi</h1>
        </div>
    </div> 
  );
}

export default Admin