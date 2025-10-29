import { useState } from 'react';
import logoimg from '../image/logo.webp';

import './DKMentor.css';
import { NavLink } from 'react-router-dom';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';
const BACKEND_URL = 'http://localhost:5000';

function DKMentor() {
  const navigate = useNavigate();
  const [job,setJob] = useState('');
  const [specialized,setSpecialized] = useState('');
  const [yearstudy,setYearstudy] = useState('');
  const [gpa,setGpa] = useState('');
  const [dkSuccess,setDkSuccess] = useState('');
  const [dkError,setDkError] = useState('');
  const storage_email = localStorage.getItem('emailCurrent');
  const handleSubmit_mentor = async (e) => {
    e.preventDefault();
    setDkSuccess('');
    setDkError('');
    try {
        const response = await axios.post(`${BACKEND_URL}/api/mentorApplication`,{
            apply_email: storage_email,
            aplly_job: job,
            specialized: specialized,
            yearstudy: yearstudy,
            gpa: gpa
        });
        setDkSuccess(response.data.message);
        setJob('');
        setSpecialized('');
        setYearstudy('');
        setGpa('');
        navigate('/');
    } catch (error) {
        setDkError(error.response?.data?.message || 'Đăng nhập thất bại.');
    }
    
  }

  return (
    <div className="dkmentor">
        <div className='message-box'>
            {dkSuccess && <p style={{ color: 'green', fontWeight: 'bold' }}>{dkSuccess}</p>}
            {dkError && <p style={{ color: 'red', fontWeight: 'bold' }}>{dkError}</p>}
        </div>
        <div className='square_dkmentor'>
            <div className='logo_login'>
                <img src={logoimg} alt='' className='logo_Bk' />
                <h1 className='tutor_login'>TUTOR</h1>
            </div>
            <form onSubmit={handleSubmit_mentor}>
                <div className='up-down'>
                    <label className='word' htmlFor='specialized'>Thuộc khoa</label>
                    <select 
                        id='specialized'
                        className='specialized_input'
                        value={specialized}
                        onChange={(e) => setSpecialized(e.target.value)}
                    >
                        <option value=''>-- Chọn khoa --</option>
                        <option value='khmt'>Khoa học máy tính</option>
                        <option value='ktmt'>Kĩ thuật máy tính</option>
                    </select>
                    <label className='word' htmlFor='role'>Chức danh hiện tại </label>
                    <select 
                        id='role'
                        className='select_input'
                        value={job}
                        onChange={(e) => setJob(e.target.value)}
                    >
                        <option value=''>-- Chọn chức danh --</option>
                        <option value='giangvien'>Giảng viên</option>
                        <option value='nghiencuusinh'>Nghiên cứu sinh</option>
                        <option value='sinhvien'>Sinh viên</option>
                        <option value='saudaihoc'>Sinh viên sau đại học</option>
                    </select>
                    <NavLink to='/'><button type="button" className='out_button'>
                        <h1 className='out_word'>Cancel</h1>
                    </button></NavLink>
                </div>
                <div className='up-down'>
                    <label className='word' htmlFor='yearstudy'>Sinh viên năm ("None" nếu không là sinh viên) </label>
                    <select 
                        id='yearstudy'
                        className='yearstudy_input'
                        value={yearstudy}
                        onChange={(e) => setYearstudy(e.target.value)}
                    >
                        <option value=''>-- Chọn năm --</option>
                        <option value='none'>None</option>
                        <option value='nam2'>Năm 2</option>
                        <option value='nam3'>Năm 3</option>
                        <option value='nam4'>Năm 4</option>
                    </select>
                    <label className='word' htmlFor='gpa'>Điểm GPA trung bình ("None" nếu không là sinh viên)</label>
                    <input 
                    type='text'
                    id='gpa'
                    placeholder='  VD: 3.6...'
                    value={gpa}
                    onChange={(e) => setGpa(e.target.value)}
                    className='gpa_input'
                    required
                    />
                    <button type='submit' className='mentor_button'>
                        <h1 className='mentor_word'>Đăng ký</h1>
                    </button>
                </div>
            </form>
        </div>
    </div>
  );
}

export default DKMentor