class UsersController < ApplicationController

  def verify_email
    user = User.find_by_email(params[:email])
    if(user == nil)
      render json: {"newUser": true}
    else
      check_status user
    end
  end

  def check_status user
    if user.ativo
      render json: user
    else
      render json:{}, :status => :forbidden
    end
  end

  def edit
    user = User.find_by_email(params[:email]);
    profile_description = Profile.find(params[:profile]).perfil
    user.update(nome_completo: params[:nome_completo], perfil: profile_description, id_perfil: params[:profile], photo_link: params[:photo_link]);
    render json: user;
  end

  def create
    primeiro_nome = params[:first_name]
    ultimo_nome = params[:last_name]
    nome_completo = primeiro_nome +" "+ultimo_nome;
    usuario = params[:email]
    senha = params[:password_digest]
    perfil = params[:profile]
    codigo_verificacao = SecureRandom.urlsafe_base64(nil, false);

    user = User.new(nome_completo: nome_completo, perfil: perfil, 
      email: usuario,usuario: usuario, senha: senha, 
      codigo_verificacao: codigo_verificacao,
      ativo: true)
    if user.save
      render json: user
    else
      user = User.find_by_email(params[:email]);
      if(user == nil)
        render json: { error: 'Invalid Email' }, status: 400;
      else
        render json: { error: 'Email already used' }, status: 401;
      end
    end
  end

  def deactivate
    user = User.find_by_id_usuario(params[:id])
    if user.senha == params[:password]
      user.ativo = false
      user.save
      render json: user
    else
      render json: { error: 'Incorrect credentials' }, status: 401
    end
  end
  
end
