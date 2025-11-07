import React, { Children } from "react";
import { Navigate, Outlet } from "react-router-dom";

const MenteeRoute = ({ children }) => {
    const userRole =  localStorage.getItem('userRole');
    if (!userRole || userRole !== 'mentee'){
        return <Navigate to='/' replace />;
    }
    return children ? children : <Outlet />;
}
export default MenteeRoute;