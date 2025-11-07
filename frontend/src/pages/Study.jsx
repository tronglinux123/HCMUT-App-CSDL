import './Study.css';
import { NavLink } from 'react-router-dom';

function Study() {

  return (
    <>
      
      <div className="study">
          <div className='ex'>

          </div>
          <div className='ex'>

          </div>
          <div className='ex'>

          </div>
          <div className='ex'>

          </div>
          <div className='ex'>

          </div>
          
          <NavLink to='/study/dangkymonhoc' className='link'>
            <div className='Dangkymoi'>
              <div className='dautron'>
                <h1>+</h1>
              </div>
              <h1 className='chuviet'>Đăng ký mới</h1>
            </div>
          </NavLink>
      </div>
      
    </>
  );
}

export default Study