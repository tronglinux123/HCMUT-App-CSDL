import React, { useState, useEffect } from 'react';
import logoimg from '../image/logo.webp';
import { NavLink } from 'react-router-dom';
import './Header.css';

const storage = localStorage;   

function Header() {
    const [userRole,setUserRole] = useState(null);
    const [isLogin, setIslogin] = useState(false);
    useEffect(() => {
        const checkStatus = () => {
            const role = storage.getItem('userRole');
            if(role) {
                setUserRole(role);
                setIslogin(true);
            } else {
                setIslogin(false);
                setUserRole(null);
            }
        };
        checkStatus();
    }, []);

    const handleLogout = () => {
        storage.removeItem('userRole');
        storage.removeItem('emailCurrent');
        setIslogin(false);
        setUserRole(null);
    };

    return (
        <header className="header">
            <div className="block1">
                <div className="menu">
                    <div className="sen"></div>
                    <div className="sen"></div>
                    <div className="sen"></div>
                </div>
                <div className="logo">
                    <NavLink to='/'><img src={logoimg} alt="logobk" className="logo_Bk"/></NavLink>
                    <h1 className="tutor">TUTOR</h1>
                </div>
            </div>
            <div className="block2">
                <NavLink to='/dangkymentor'>
                    <button className="DKMentor">
                        <h1 className="letterDK">Đăng ký Mentor</h1>
                    </button>
                </NavLink>
                <div className='auth-section'>
                    {isLogin ? (
                        <button 
                            onClick={handleLogout}
                            className='DX'
                        >
                            <h1 className="letterDN">Đăng xuất ({userRole})</h1>
                        </button>
                    ) : (
                        <NavLink to='/login'>
                            <button className="DN">
                                <h1 className="letterDN">Đăng Nhập</h1>
                            </button>
                        </NavLink>
                    )}
                    
                </div>
            </div>
        </header>
    );
}

export default Header;