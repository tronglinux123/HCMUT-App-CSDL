import React, { useState, useEffect } from 'react';
import axios from 'axios';
import './App.css';

import AdminRoute from './component/AdminRoute';
import MentorApplyRoute from './component/MentorApplyRoute';

import Home from './pages/Home';
import Library from './pages/Library';
import SettingStudy from './pages/SettingStudy';
import Study from './pages/Study';
import Admin from './pages/Admin';

import Login from './layout/Login';
import DKMentor from './layout/DKMentor';
import RootLayout from './layout/RootLayout';

import { Route, createBrowserRouter, createRoutesFromElements, RouterProvider } from 'react-router-dom';

function App() {
  const router = createBrowserRouter(
    createRoutesFromElements(
      <>
      <Route path='/' element={<RootLayout />}>
        <Route index element={<Home />} />
        <Route path='library' element={<Library />} />
        <Route path='settingstudy' element={<SettingStudy />} />
        <Route path='study' element={<Study />} />
      </Route>
      <Route path='/login' element={<Login />} />
      <Route 
        path='/dangkymentor' 
        element={
          <MentorApplyRoute>
            <DKMentor />
          </MentorApplyRoute>
        } 
      />
      <Route 
        path='/admin'
        element={
          <AdminRoute>
            <Admin />
          </AdminRoute>
        }
      />
      </>
    )
  )

  return (
    <>
      <RouterProvider router={router} />
    </>
  );
}

export default App
