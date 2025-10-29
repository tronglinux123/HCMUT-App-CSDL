import React from "react";

import Sidebar from "../component/Sidebar";
import Header from '../component/Header';

import { Outlet } from "react-router-dom";
function RootLayout() {

  return (
    <>
      <div className='header-layout'>
        <Header />
      </div>
      <div className='main-layout'>
        <Sidebar />
        <main className='content'>
          <Outlet />
        </main>
      </div>
    </>
  );
}

export default RootLayout