import React, { Children } from "react";
import { Navigate, Outlet } from "react-router-dom";

const MentorRoute = ({ children }) => {
    const userRole =  localStorage.getItem('userRole');
    if (!userRole || userRole !== 'mentor'){
        return <Navigate to='/' replace />;
    }
    return children ? children : <Outlet />;
}
export default MentorRoute;