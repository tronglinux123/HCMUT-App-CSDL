import './Admin.css';
import axios from 'axios';
import React, { use, useState, useEffect } from 'react';
import background from '../image/background.jpg';

function Admin() {
  const BACKEND_URL = 'http://localhost:5000';
  const userRole =  localStorage.getItem('userRole');
  const [appliCations, setAppliCations] = useState([]);
  useEffect(() => {
    const menteeApplyForm = async () => {
      try {
        const response = await axios.post(`${BACKEND_URL}/api/ApplicationCheckByAdmin`);
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

  const handleDelete = async (apply) => {
    console.log(apply.id);
    const response = await axios.post(`${BACKEND_URL}/api/deleteapply`,{
        id: apply.id
    });
    console.log('success');
  }
  const handleAccess = async (apply) => {
    console.log(apply.id);
    const response = await axios.post(`${BACKEND_URL}/api/accessapply`,{
        id: apply.id
    });
    console.log('hi');
  }
  return (     
    <div className='admin'>             
    <img src={background} alt='' className='background' />        
          <div className='title-Apply'>
            <h1>Danh sách đăng ký Mentor</h1>
          </div>
          <div className="ApplicationCheckByAdmin">
            <div className='boc_ApplicationCheckByAdmin'>    
              {appliCations.map((apply) => (
                <div className='ApplyCard'>
                    <h1 className='hoten'>{apply.name}</h1>
                    <h1>|</h1>
                    <h1 className='emailapply'>Email: {apply.apply_email}</h1>
                    <h1>|</h1>
                    <h1 className='jobapply'>{apply.aplly_job}</h1>
                    <h1>|</h1>
                    <h1 className='yearapply'>Year: {apply.yearstudy}</h1>
                    <h1>|</h1>
                    <h1 className='specializedapply'>Faculty: {apply.specialized}</h1>
                    <h1>|</h1>
                    <h1 className='gpaapply'>Gpa: {apply.gpa}</h1>
                    <button className='delete-apply' onClick={() => handleDelete(apply)}>
                      
                    </button>
                    <button className='access-apply' onClick={() => handleAccess(apply)}>
                  
                    </button>
                </div>
              ))}
            </div>  
          </div>
        <div className='title-Apply'>
            <h1>Danh sách đăng ký môn</h1>
          </div>
        <div className="ApplyForMentor">
            <h1>ahihiihi</h1>
        </div>
        <div className='title-Apply'>
            <h1>Phản hồi của Mentee</h1>
          </div>
        <div className="Response">
            <h1>ahihiihi</h1>
        </div>
        <div className="">
        </div>
    </div> 
  );
}

export default Admin