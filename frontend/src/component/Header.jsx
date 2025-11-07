import React, { useState, useRef, useEffect } from 'react';
import logoimg from '../image/logo.webp';
import avt from '../image/avatar.png';
import { NavLink } from 'react-router-dom';
import './Header.css';

const storage = localStorage;   

function Header() {
    const [open, setOpen] = useState(false);
    const [userRole,setUserRole] = useState(null);
    const [isLogin, setIslogin] = useState(false);
    const menuRef = useRef(null); // ref cho vùng menu
    const buttonRef = useRef(null); // ref cho nút avatar

    useEffect(() => {
        const handleClickOutside = (event) => {
            
            if (
                menuRef.current &&
                !menuRef.current.contains(event.target) &&
                !buttonRef.current.contains(event.target)
            ) {
                setOpen(false);
            }
            };

        document.addEventListener("mousedown", handleClickOutside);

        return () => {
            document.removeEventListener("mousedown", handleClickOutside);
        };
    }, []);
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
        storage.removeItem('nameCurrent');
        setIslogin(false);
        setUserRole(null);
        window.location.reload();
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
                {/* <NavLink to='/dangkymentor'>
                    <button className="DKMentor">
                        <h1 className="letterDK">Đăng ký Mentor</h1>
                    </button>
                </NavLink> */}
                <div className='auth-section'>
                    {isLogin ? (
                        <div className='avt-container'>
                            <button className='avt' ref={buttonRef} onClick={() => setOpen(!open)}>
                                <img src={avt} alt='' className='avtimg' />
                            </button>
                            {open && (
                                <ul ref={menuRef} className='menuavt'>
                                    <li>Thông tin cá nhân</li>
                                    <li onClick={handleLogout}>Đăng xuất</li>
                                </ul>
                            )}
                        </div>
                        // <button 
                        //     onClick={handleLogout}
                        //     className='DX'
                        // >
                        //     <h1 className="letterDN">Đăng xuất ({userRole})</h1>
                        // </button>
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