import logoimg from '../image/logo.webp';
import emailimg from '../image/email.png';
import lock from '../image/lock.png';
import nameimg from '../image/name.png';
import phoneimg from '../image/phone.png';
import axios from 'axios';
import React, { use, useState } from 'react';

import './Login.css';
import { NavLink } from 'react-router-dom';
import { useNavigate } from 'react-router-dom';

function Login() {
  const navigate = useNavigate();
  // đăng nhậ<p></p>
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  // đăng kí
  const [name, setName] = useState('');
  const [email_dk, setEmailDk] = useState('');
  const [pass_dk, setPassDk] = useState('');
  const [pass_confirm, setPassConfirm] = useState('');
  const [phone, setPhone] = useState('');

  const [loginError, setLoginError] = useState('');
  const [loginSuccess, setLoginSuccess] = useState('');

  const [dkError, setDkError] = useState('');
  const [dkSuccess, setDkSuccess] = useState('');
  
  const BACKEND_URL = 'http://localhost:5000';
  const [move, setMove] = useState(false);

  const handleSubmit_login = async (e) => {
    e.preventDefault();
    setLoginError('');
    setLoginSuccess('')
    setDkError('');
    setDkSuccess('');
    try {
      const response = await axios.post(`${BACKEND_URL}/api/login`,{
        email: email,
        password: password
      });
      setLoginSuccess(response.data.message); 
      setEmail('');
      setPassword('');
      const userRole = response.data.user.role;
      const emailCurrent = response.data.user.email;
      localStorage.setItem('userRole', userRole);
      localStorage.setItem('emailCurrent', emailCurrent);
      if (userRole === 'admin'){
        navigate('/admin');
      } else {
        navigate('/');
      }
      console.log('Đăng nhập thành công:', response.data);
    } catch (error) {
      setLoginError(error.response?.data?.message || 'Đăng nhập thất bại.');
    }
  }

  const handleSubmit_Dk = async (e) => {
    e.preventDefault();
    setDkError('');
    setDkSuccess('');
    setLoginError('');
    setLoginSuccess('')
    if (pass_dk!=pass_confirm){
      setDkError('Mật khẩu không trùng nhau');
      return;
    }
    try {
      const response = await axios.post(`${BACKEND_URL}/api/register`,{
        name: name,
        email_dk: email_dk,
        pass_dk: pass_dk,
        phone: phone
      });
      setDkSuccess(response.data.message); 
      setName('');
      setEmailDk('');
      setPassDk('');
      setPassConfirm('');
      setPhone('');
      console.log('Đăng ký thành công:', response.data);
    } catch (error) {
      setDkError(error.response?.data?.message || 'Đăng ký thất bại.');
    }
  }

  const handleDK = () => {
    setMove(!move);
  }
  return (
    <div className="login">
      <div className='message-box'>
        {loginSuccess && <p style={{ color: 'green', fontWeight: 'bold' }}>{loginSuccess}</p>}
        {loginError && <p style={{ color: 'red', fontWeight: 'bold' }}>{loginError}</p>}
        {dkSuccess && <p style={{ color: 'green', fontWeight: 'bold' }}>{dkSuccess}</p>}
        {dkError && <p style={{ color: 'red', fontWeight: 'bold' }}>{dkError}</p>}
      </div>
      <div className={`square_login ${move ? 'move' : ''}`}>
        <div className='logo_login'>
          <img src={logoimg} alt='' className='logo_Bk' />
          <h1 className='tutor_login'>TUTOR</h1>
        </div>
        <form onSubmit={handleSubmit_login}>
          <div className='email'>
            <img src={emailimg} alt='' className='email_img' />
            <input 
              type='email'
              placeholder='Nhập email...'
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              className='email_input'
              required
            />
          </div>
          <div className='pass'>
            <img src={lock} alt='' className='pass_img' />
            <input 
              type='password'
              placeholder='Nhập mật khẩu...'
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              className='pass_input'
              autoComplete="new-password" 
              required
            />
          </div>
          <button type='submit' className='login_buttom'>
            <h1 className='login_word'>Đăng nhập</h1>
          </button>
        </form>
        <button className='dk_buttom' onClick={handleDK}>
          <h1 className='dk_word'>Đăng ký</h1>
        </button>
      </div>

      {/* ######################################################################## */}
      
      <div className={`square_dk ${move ? 'move' : ''}`}>
        <div className='logo_login'>
          <img src={logoimg} alt='' className='logo_Bk' />
          <h1 className='tutor_login'>TUTOR</h1>
        </div>
        <form onSubmit={handleSubmit_Dk}>
          <div className='name'>
            <img src={nameimg} alt='' className='name_img' />
            <input 
              type='text'
              placeholder='Nhập họ và tên...'
              value={name}
              onChange={(e) => setName(e.target.value)}
              className='name_input'
              required
            />
          </div>
          <div className='email_dk'>
            <img src={emailimg} alt='' className='email_img' />
            <input 
              type='email'
              placeholder='Nhập email...'
              value={email_dk}
              onChange={(e) => setEmailDk(e.target.value)}
              className='email_dk_input'
              required
            />
          </div>
          <div className='pass_dk'>
            <img src={lock} alt='' className='pass_img' />
            <input 
              type='password'
              placeholder='Nhập mật khẩu...'
              value={pass_dk}
              onChange={(e) => setPassDk(e.target.value)}
              className='pass_dk_input'
              autoComplete="new-password" 
              required
            />
          </div>
          <div className='pass_confirm'>
            <img src={lock} alt='' className='pass_img' />
            <input 
              type='password'
              placeholder='Nhập lại mật khẩu...'
              value={pass_confirm}
              onChange={(e) => setPassConfirm(e.target.value)}
              className='pass_confirm_input'
              required
            />
          </div>
          <div className='phone'>
            <img src={phoneimg} alt='' className='phone_img' />
            <input 
              type='tel'
              placeholder='Nhập số điện thoại...'
              value={phone}
              onChange={(e) => setPhone(e.target.value)}
              className='phone_input'
              required
            />
          </div>
          {/* <div className='errorr'>
            {error && <p style={{ color: 'red', marginTop: '4px' }}>{error}</p>}
          </div> */}
          <button type='submit' className='dk_button'>
            <h1 className='dk_word'>Đăng ký</h1>
          </button>
        </form>
      </div>
    </div>
  );
}

export default Login