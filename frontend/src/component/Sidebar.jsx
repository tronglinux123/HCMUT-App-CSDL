import React from 'react';
import { NavLink } from 'react-router-dom';
import './Sidebar.css';

import book1 from '../image/book1.png';
import study1 from '../image/study1.png';
import write1 from '../image/write1.png';

import book2 from '../image/book2.png';
import study2 from '../image/study2.png';
import write2 from '../image/write2.png';

const sidebarItems = [
  { id: 1, name: "Thư viện", icon: book1, hoverIcon: book2, path:'/library' }, 
  { id: 2, name: "Lớp học", icon: study1, hoverIcon: study2, path:'/study' }, 
  { id: 3, name: "Tùy chỉnh lớp học", icon: write1, hoverIcon: write2, path:'/settingstudy' }, 
];

function Sidebar() {
  return (
    <aside className="sidebar">
      <nav>
        <ul>
          {sidebarItems.map((item) => (
            <li key={item.id}>
            <NavLink 
              to={item.path} 
              className={({isActive})=>`sidebar-item ${isActive ? 'active' : ''}`
              }
            >
                <img
                  src={item.icon}
                  alt={item.name}
                  className='sidebar-icon-default'
                />
                <img
                  src={item.hoverIcon}
                  alt={item.name + " hover"}
                  className='sidebar-icon-hover'
                />
                <span className='menu-name'>{item.name}</span>
            </NavLink>
            </li>
          ))}
        </ul>
      </nav>
    </aside>
  );
}

export default Sidebar;