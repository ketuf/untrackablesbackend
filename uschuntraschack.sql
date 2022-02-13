PGDMP         :                z            untrack    14.1 (Debian 14.1-1.pgdg110+1)    14.1 (Debian 14.1-1.pgdg110+1) 9    6           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            7           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            8           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            9           1262    16721    untrack    DATABASE     \   CREATE DATABASE untrack WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.UTF-8';
    DROP DATABASE untrack;
                postgres    false            �            1259    16727    _chatter    TABLE     J  CREATE TABLE public._chatter (
    id text NOT NULL,
    email text NOT NULL,
    password text NOT NULL,
    nickname text NOT NULL,
    isconfirmedemail boolean DEFAULT false NOT NULL,
    phonenumber text,
    phonenumberconfirmtoken text,
    isconfirmedphonenumber boolean DEFAULT false NOT NULL,
    secret text NOT NULL
);
    DROP TABLE public._chatter;
       public         heap    uschun    false            �            1259    16829    _comment    TABLE     �   CREATE TABLE public._comment (
    id bigint NOT NULL,
    date timestamp without time zone NOT NULL,
    value text NOT NULL,
    chatter_id text,
    message_id bigint
);
    DROP TABLE public._comment;
       public         heap    uschun    false            �            1259    16828    _comment_id_seq    SEQUENCE     x   CREATE SEQUENCE public._comment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public._comment_id_seq;
       public          uschun    false    218            :           0    0    _comment_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public._comment_id_seq OWNED BY public._comment.id;
          public          uschun    false    217            �            1259    16722    _conduit_version_pgsql    TABLE     �   CREATE TABLE public._conduit_version_pgsql (
    versionnumber integer NOT NULL,
    dateofupgrade timestamp without time zone NOT NULL
);
 *   DROP TABLE public._conduit_version_pgsql;
       public         heap    uschun    false            �            1259    16743 
   _following    TABLE     f   CREATE TABLE public._following (
    id bigint NOT NULL,
    chatter_id text,
    follower_id text
);
    DROP TABLE public._following;
       public         heap    uschun    false            �            1259    16742    _following_id_seq    SEQUENCE     z   CREATE SEQUENCE public._following_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public._following_id_seq;
       public          uschun    false    212            ;           0    0    _following_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public._following_id_seq OWNED BY public._following.id;
          public          uschun    false    211            �            1259    16759    _like    TABLE     �   CREATE TABLE public._like (
    id bigint NOT NULL,
    date timestamp without time zone NOT NULL,
    chatter_id text,
    message_id bigint
);
    DROP TABLE public._like;
       public         heap    uschun    false            �            1259    16758    _like_id_seq    SEQUENCE     u   CREATE SEQUENCE public._like_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public._like_id_seq;
       public          uschun    false    216            <           0    0    _like_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public._like_id_seq OWNED BY public._like.id;
          public          uschun    false    215            �            1259    16750    _message    TABLE     �   CREATE TABLE public._message (
    id bigint NOT NULL,
    value text NOT NULL,
    date timestamp without time zone NOT NULL,
    from_id text,
    to_id text,
    isprivate boolean DEFAULT false NOT NULL
);
    DROP TABLE public._message;
       public         heap    uschun    false            �            1259    16749    _message_id_seq    SEQUENCE     x   CREATE SEQUENCE public._message_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public._message_id_seq;
       public          uschun    false    214            =           0    0    _message_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public._message_id_seq OWNED BY public._message.id;
          public          uschun    false    213            |           2604    16832    _comment id    DEFAULT     j   ALTER TABLE ONLY public._comment ALTER COLUMN id SET DEFAULT nextval('public._comment_id_seq'::regclass);
 :   ALTER TABLE public._comment ALTER COLUMN id DROP DEFAULT;
       public          uschun    false    217    218    218            x           2604    16746    _following id    DEFAULT     n   ALTER TABLE ONLY public._following ALTER COLUMN id SET DEFAULT nextval('public._following_id_seq'::regclass);
 <   ALTER TABLE public._following ALTER COLUMN id DROP DEFAULT;
       public          uschun    false    212    211    212            {           2604    16762    _like id    DEFAULT     d   ALTER TABLE ONLY public._like ALTER COLUMN id SET DEFAULT nextval('public._like_id_seq'::regclass);
 7   ALTER TABLE public._like ALTER COLUMN id DROP DEFAULT;
       public          uschun    false    215    216    216            y           2604    16753    _message id    DEFAULT     j   ALTER TABLE ONLY public._message ALTER COLUMN id SET DEFAULT nextval('public._message_id_seq'::regclass);
 :   ALTER TABLE public._message ALTER COLUMN id DROP DEFAULT;
       public          uschun    false    214    213    214            +          0    16727    _chatter 
   TABLE DATA           �   COPY public._chatter (id, email, password, nickname, isconfirmedemail, phonenumber, phonenumberconfirmtoken, isconfirmedphonenumber, secret) FROM stdin;
    public          uschun    false    210   �A       3          0    16829    _comment 
   TABLE DATA           K   COPY public._comment (id, date, value, chatter_id, message_id) FROM stdin;
    public          uschun    false    218   �Q       *          0    16722    _conduit_version_pgsql 
   TABLE DATA           N   COPY public._conduit_version_pgsql (versionnumber, dateofupgrade) FROM stdin;
    public          uschun    false    209   U       -          0    16743 
   _following 
   TABLE DATA           A   COPY public._following (id, chatter_id, follower_id) FROM stdin;
    public          uschun    false    212   kU       1          0    16759    _like 
   TABLE DATA           A   COPY public._like (id, date, chatter_id, message_id) FROM stdin;
    public          uschun    false    216   �c       /          0    16750    _message 
   TABLE DATA           N   COPY public._message (id, value, date, from_id, to_id, isprivate) FROM stdin;
    public          uschun    false    214   0g       >           0    0    _comment_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public._comment_id_seq', 4, true);
          public          uschun    false    217            ?           0    0    _following_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public._following_id_seq', 6, true);
          public          uschun    false    211            @           0    0    _like_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public._like_id_seq', 4, true);
          public          uschun    false    215            A           0    0    _message_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public._message_id_seq', 18, true);
          public          uschun    false    213            �           2606    16737    _chatter _chatter_email_key 
   CONSTRAINT     W   ALTER TABLE ONLY public._chatter
    ADD CONSTRAINT _chatter_email_key UNIQUE (email);
 E   ALTER TABLE ONLY public._chatter DROP CONSTRAINT _chatter_email_key;
       public            uschun    false    210            �           2606    16739    _chatter _chatter_nickname_key 
   CONSTRAINT     ]   ALTER TABLE ONLY public._chatter
    ADD CONSTRAINT _chatter_nickname_key UNIQUE (nickname);
 H   ALTER TABLE ONLY public._chatter DROP CONSTRAINT _chatter_nickname_key;
       public            uschun    false    210            �           2606    16741 -   _chatter _chatter_phonenumberconfirmtoken_key 
   CONSTRAINT     {   ALTER TABLE ONLY public._chatter
    ADD CONSTRAINT _chatter_phonenumberconfirmtoken_key UNIQUE (phonenumberconfirmtoken);
 W   ALTER TABLE ONLY public._chatter DROP CONSTRAINT _chatter_phonenumberconfirmtoken_key;
       public            uschun    false    210            �           2606    16735    _chatter _chatter_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public._chatter
    ADD CONSTRAINT _chatter_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public._chatter DROP CONSTRAINT _chatter_pkey;
       public            uschun    false    210            �           2606    16836    _comment _comment_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public._comment
    ADD CONSTRAINT _comment_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public._comment DROP CONSTRAINT _comment_pkey;
       public            uschun    false    218            ~           2606    16726 ?   _conduit_version_pgsql _conduit_version_pgsql_versionnumber_key 
   CONSTRAINT     �   ALTER TABLE ONLY public._conduit_version_pgsql
    ADD CONSTRAINT _conduit_version_pgsql_versionnumber_key UNIQUE (versionnumber);
 i   ALTER TABLE ONLY public._conduit_version_pgsql DROP CONSTRAINT _conduit_version_pgsql_versionnumber_key;
       public            uschun    false    209            �           2606    16748    _following _following_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public._following
    ADD CONSTRAINT _following_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public._following DROP CONSTRAINT _following_pkey;
       public            uschun    false    212            �           2606    16764    _like _like_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public._like
    ADD CONSTRAINT _like_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public._like DROP CONSTRAINT _like_pkey;
       public            uschun    false    216            �           2606    16757    _message _message_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public._message
    ADD CONSTRAINT _message_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public._message DROP CONSTRAINT _message_pkey;
       public            uschun    false    214            �           1259    16837    _comment_chatter_id_idx    INDEX     R   CREATE INDEX _comment_chatter_id_idx ON public._comment USING btree (chatter_id);
 +   DROP INDEX public._comment_chatter_id_idx;
       public            uschun    false    218            �           1259    16843    _comment_message_id_idx    INDEX     R   CREATE INDEX _comment_message_id_idx ON public._comment USING btree (message_id);
 +   DROP INDEX public._comment_message_id_idx;
       public            uschun    false    218            �           1259    16767    _following_chatter_id_idx    INDEX     V   CREATE INDEX _following_chatter_id_idx ON public._following USING btree (chatter_id);
 -   DROP INDEX public._following_chatter_id_idx;
       public            uschun    false    212            �           1259    16773    _following_follower_id_idx    INDEX     X   CREATE INDEX _following_follower_id_idx ON public._following USING btree (follower_id);
 .   DROP INDEX public._following_follower_id_idx;
       public            uschun    false    212            �           1259    16793    _like_chatter_id_idx    INDEX     L   CREATE INDEX _like_chatter_id_idx ON public._like USING btree (chatter_id);
 (   DROP INDEX public._like_chatter_id_idx;
       public            uschun    false    216            �           1259    16799    _like_message_id_idx    INDEX     L   CREATE INDEX _like_message_id_idx ON public._like USING btree (message_id);
 (   DROP INDEX public._like_message_id_idx;
       public            uschun    false    216            �           1259    16779    _message_from_id_idx    INDEX     L   CREATE INDEX _message_from_id_idx ON public._message USING btree (from_id);
 (   DROP INDEX public._message_from_id_idx;
       public            uschun    false    214            �           1259    16785    _message_to_id_idx    INDEX     H   CREATE INDEX _message_to_id_idx ON public._message USING btree (to_id);
 &   DROP INDEX public._message_to_id_idx;
       public            uschun    false    214            �           2606    16838 !   _comment _comment_chatter_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public._comment
    ADD CONSTRAINT _comment_chatter_id_fkey FOREIGN KEY (chatter_id) REFERENCES public._chatter(id) ON DELETE SET NULL;
 K   ALTER TABLE ONLY public._comment DROP CONSTRAINT _comment_chatter_id_fkey;
       public          uschun    false    218    210    3206            �           2606    16844 !   _comment _comment_message_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public._comment
    ADD CONSTRAINT _comment_message_id_fkey FOREIGN KEY (message_id) REFERENCES public._message(id) ON DELETE SET NULL;
 K   ALTER TABLE ONLY public._comment DROP CONSTRAINT _comment_message_id_fkey;
       public          uschun    false    3213    214    218            �           2606    16768 %   _following _following_chatter_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public._following
    ADD CONSTRAINT _following_chatter_id_fkey FOREIGN KEY (chatter_id) REFERENCES public._chatter(id) ON DELETE SET NULL;
 O   ALTER TABLE ONLY public._following DROP CONSTRAINT _following_chatter_id_fkey;
       public          uschun    false    210    212    3206            �           2606    16774 &   _following _following_follower_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public._following
    ADD CONSTRAINT _following_follower_id_fkey FOREIGN KEY (follower_id) REFERENCES public._chatter(id) ON DELETE SET NULL;
 P   ALTER TABLE ONLY public._following DROP CONSTRAINT _following_follower_id_fkey;
       public          uschun    false    3206    212    210            �           2606    16794    _like _like_chatter_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public._like
    ADD CONSTRAINT _like_chatter_id_fkey FOREIGN KEY (chatter_id) REFERENCES public._chatter(id) ON DELETE SET NULL;
 E   ALTER TABLE ONLY public._like DROP CONSTRAINT _like_chatter_id_fkey;
       public          uschun    false    210    216    3206            �           2606    16800    _like _like_message_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public._like
    ADD CONSTRAINT _like_message_id_fkey FOREIGN KEY (message_id) REFERENCES public._message(id) ON DELETE SET NULL;
 E   ALTER TABLE ONLY public._like DROP CONSTRAINT _like_message_id_fkey;
       public          uschun    false    214    3213    216            �           2606    16811    _message _message_from_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public._message
    ADD CONSTRAINT _message_from_id_fkey FOREIGN KEY (from_id) REFERENCES public._chatter(id) ON DELETE CASCADE;
 H   ALTER TABLE ONLY public._message DROP CONSTRAINT _message_from_id_fkey;
       public          uschun    false    3206    214    210            �           2606    16816    _message _message_to_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public._message
    ADD CONSTRAINT _message_to_id_fkey FOREIGN KEY (to_id) REFERENCES public._chatter(id) ON DELETE CASCADE;
 F   ALTER TABLE ONLY public._message DROP CONSTRAINT _message_to_id_fkey;
       public          uschun    false    210    214    3206            +   �  x�MWǲ�ڒW}�����.F��>z�����_�ynGG�#m�������R����o���cָ���i��3��r���o���H��*��SđE�)ii�/۩'k7�4uu�)�XI�A�t��gr���>��"��'70i_^��1P�����8�Qt2��X��s�,x2%l�B�:g�����nyph�Y�2�}�f���ܮ����q�}?ڋ����)3R��(8��xj�y٬��
?o���������K����dn�#^�yY�q���w�y�=ey/�O��wG�� �x_r{��6���sI�T���)�;ߴ��[iTd�t�Up.i�F���ջ�a�7��б	���(|�JgQ�C��/����V��J�� ����Ћ�������[���h6���w�L�g~ea�6I�j�8�?6nͧ��}�G)w߭?Xc�g�.�c?����}���z�}���p�_-���=��j?X����Ku��fBux˓�ʻ�|����y��XH�7��tu�Kk�'�l+Vh�WIdkYo}��U�mCr��]�,����.���vnQ�Q��D�/��7>s3�����n�syת�5Q��"�W�����k;)����^���g]#��>�)B�7�Z���9J��)e�̙�>]l�x�l�(�>t�.����zE�ʷ����1�<p�i#?�Mn���4�$)�&�E�<����n���;������n��!?�k��?�P۫D\4�o��gH�ocA�ԉ?�O�齍
��_GJU4�2���n���u��*>Q]%��-ʴ���<����8��ɯ��?����lx4-=�h:��9���.�f���M��t8Y?t4&�?�q�����v?o���R��wb���aLQ��E�C7��O�U?I��;�Ǻ颱)��fN�.�v���Yi׏v;�?�g��m���AAK/���(��ie����ce�ݦR
I�|l?��p�0�6߲鳾���a�Gnu_�etx+(�}�^����
�Ik+��#ϓw5��W�&����s3�v�;ǳ?A��v�WwF7߲N�#r>Q�*7�cRV����{w����ެe`9��4cm�iF/�u�^ا��M��M5��Yf�Uxk����-�C�$���kʲ�߽���</��k6eƓ1���f笏��y�(M��-�C�K��%�!��v(����&.��ݸ͞�Ĩ�x��<j c^^'�M����ڊ��Nܰ��� t�؄��}���1'���gL��'k�g~
֩�߸�>���b��2o�ގ[4�����F۹:Q
S�\��(N��>�uٸN�y[E1�F`��6q���>E)4�1�^�Yۄmo7EY�q�c�+�)�o�hP�U�i��>Y0�ߛJ�ȻjБ���(����r����s�df�J� +Q�f7C���F����&<���u�3֯&��nwqDT~���[�,��!Y��L��3i��������q�lw��ee�_?�q���j�v:��V�{j7�.M*lyl?v����[D�v�vͮ�~۳ja*���������Ȓ���a�&���{|�o+oa�E��y�&�-|�e���/��
l���7��p����>]�a���q_�;u�$蒸�U�������_j�xe���#�[l�r��[��5>l������.7M�~���\��������KO0�H3��o��w���II&�0űIÜ.�`�(���H1�)�#����hĬ-���)VJb��R`�ы��qF�&AD�~a��(D4��	�5��Zj.��� �V�aI�&+����l%�DkmJ9�Bp�׌�g�R 
S���YM�L<&�5gT!���/��a7q%�Jr�8���B�fn�R1B��Jq�܁k՚k�	Ly��_�`s��#�~/�,�ʰPS���D
A5`(�/�Lr1#g�(���-�Trrv$S���i�(��
D�.N�&ZQ"'3sC*5UG(Q��75��i���|��f�
j,a�c����V	T`��P�������V�-�"��w�8(��Zs(�D� ��f#�~V�����BAw5N��%w�	�%f�j�B�z�k����H���@�΍T��f�% ��a*�f��e�O8�x)ɔ>�%U3�Ş�Sf��D	*	��a�P[�e
?q	H��)`P�{���.!#xam`MՓ���3� �h�sf��� ��Go����D�5��L	�B�B�;�f�0	UQoh�{����F	W % �A�8Y���p^-a5����c�_�? @�M|S������g��	+��V��	� "�h��Nl��2�C����B��T��R�C3L1����?p��%�������+|-����a\�ϓ��l�7I#u4ڛ��l��lf?���$G]��J���K{�4�:>�#yb��H0�6��yx�R��mEBO,�z�	�G�M�~��b���/���uo�N
b"�q��><fÜN$�7-O��qD��О���.��2?<���B����M�ۚ�l]W�N��FB�P��P!���:�;6���!���\Ĕ϶Zl��z_ ��ʤȦ=��FB[&��p&[���"K���$���tOW����F(��Æ%{�VSȢ�n�w��h�7n�l�̸ެ�Fk�2��Ϸ����BK��jz�&!+D�d���%��D@D:���j���sA'8�@���̀\��u��p[w��}�S1"@��f\Cn�F��I-�?R���0��,�
O�h5,󺒛�a	'(�
Ɏ~_��K���u+趂	�l����$�k.E%�c��h�|�-J����i�_/a,�U��'��P����%P�ݶs��լ�+��ZP}��*�Dl9?�bAWF`�L���u�aB1_�bR������.f����	�w��s'�\�_"�Y��-����9P9j�%��T/�tm���^ ^ �i��+h���^⤐�ޑ�LJ�A٨��f�ZL0�(v@hm�|�� ����'�Mo�(1(���y%^�c����6Ы�m��l��;b{�:���A*�*Ό',���ɱ>���GA������D;5�_B�����a�3%棩֒
�?�Q�ѧ/�哝���m�+�@�(k�~�·?M�����	��[������m7{���5�}ݯW�&h�}�Q�9F����kȿ��(���T�'h��J��cu��@kxa�=��ˆ�O����*��^��Q�����{9]����@�p�p�Thdi輄_V�����bG��>��r�R �Fz=��J��	�./_e�>RM���1��5�{�1��[Dj�������/�ML.�L�%}�����W�Z��kC�;�%�fS�C~��{�n��:�+ѵ�����g;����S��bp#�̈��b��M@\��Y���
.�@�.;������`j��������6|*��u�tm��#X@�C�q��Pb*k��u=J�1h��a�r3`��a{�V�pUO�s;��VW�H��9�!���JN�3��wc3��w�g����݄�W={��>}sc�d���J=	��
:}��2��Bc��7�4!�	+�Xɬ#&��g�_b�} ��?,�n@���vGz!ˇ����=��&����^�	9�C{��t����gi�%�[#+zo��щ߷�n��b�p��]��b��#���d$�x�"jq�d:])�,���E���z�9����p��(�Lp���\������
�{��#ֲZd+l2չ�)cs�q'�`k�==�Ҟ�g;�^��1t�\��NOt��P��$oG)L���	}=��;Kb��"��'��f���ԗ+�G	��ٙV$��^�_B&b�?�kW;tڂg(�] .��cÞ3F�V��ߙl}��U|�EF����~>��)��#�BoF��d����g�A�,D��w�N��ٻ:��i5�s����;�_bB?�%��j���?~����H�x>      3   X  x���Kr�H�9E_��Y����$!�@H�$fL����Ƨ�=Wh��ZTT��7��:�
��1���#P�����7�+�X�}?����kT��^��x��_��de��>�eUi����ɂ�gJ�7/�T�|�ߧ?���)n�����˔��@�tQ�>�ނ�����9��7n� R?��G4
a�|�!�IFR��i�p��RjhFEO��*܆X��%�P�Z��d��4|3)4�,�ɻ�8y+N^��d7�vQ��7h��P�zN
Pc��!�0������J�D�����"�@U�v���.�a�����.D�pd�-]q,\lW�%����� �=$�q� �L��S��a�4]����HKw(
�ҌW��<�}׃6�
!�%$����fI�d]�H��v�8�����Mc���w��| �Ρ�L�Tͱ6zi���J�x� Dsl�t�]Dϫ�,в��}�lжa�g[Q�I�ӱY8����8�É����V@"�E}Z�À>���m��e������]��n�]����rHW�t���J��>k�U��w�G�q<SqKи�{� [��RqRφ{��w�(���;�Yf�lY��"S�fӦR���
f)�a���{`�4�.�˻��98�y.�I�s$-jNȵ�P��2����������U%an7����M��\x�K��ˤ1�6����K%��9���yJ��Զ>
��t���-O���-�J�&�0��	z�y�P�)�^�.W^�.}��M�o�ع���.)��Zp��j��`��o��Ø�m`'7�W�\1�C0#����nٔ�nw�/�O_�+	W�$�	$����h�6*A1      *   T   x�mɻ�0�:L����3̒��HK��� K���D�5�фo�N�X�C��7۷��#M��
�8�Gk\�:�lz��^1��      -   _  x��WW��ʒ��w1��'F��  �y!!�W?�o�0-�T&�8����/2���w�8S�z���y��+��O��,����:��#x�G�-�آ��t4>V�ܗ�O~VD�>MC��n��uɨ�M��;��:�Gϟ�����C�L:����n
U2}�WeN_�(<���ڧ+��	;��l�y�o,��G�Ze6���\9���p�1,ey�&[W�ggU�]�UN�cR�gǟ.ݺ��Mpcy���tw�w>��oy�Sq�"�t~V�.-rƛ��*'i^M�z�y��d�����m�xS����[�X�E~<�I�*�O߶�������e�̧A��2��{��	ރ�1��zwX�=����)t˲��t�:B-����oj����ʱc��ϩ���	O��(���S��1:���w������&�S��r�-?�b�����5�|��%��ž���9��8��.w���#��Wţ	�U�/L�Vv�3��G�vMX��덞��ófI(1�=���\�5:Hs�լ�x��$̷��>����E���Y���C����ڡħh=��@����n��X���~�\ik�,ڸ�C��)�� ��^��ht��k�o�;g�%e$��sQ���}�Fi��,�����/�}��^�'����ͼ�ٸh64��i�χ��C�.R��U8k3K#��|�MX�Q�C�L��,��I{!������3��Y��� ���a�E��5L�t�1V������9��I��]\�~���R�����w3��Ո��8o��R����:��p�^Ye�/a����6W�fR�#LqlR�0'�,�"��C�A1RLi�0È0�45@7�����JIL���"\
,1zS�1����!��#�o����R00�L`���+�	h���k"�29l�p�6�E��&��S.Gx�(~��`�0���_�d��K`"�KFB�p�l	�A�+qV�s���,RsG����GT���.�U[�9'��r~SWt��I�� ǣ`��P�;�BaL�����j�T�_"��bA��Q�{F����J���TQ(��]�2M��D�0f��j��P
�!�ojL�x'���o�X��X��ƞ�7V	Tb�W��Dq	�=%� ��npt�����؛�juR|-��PN��!+�FR��z/);�BAw5N	��%6���
3F5}#N}�5eil��&���^ h�N*�H+� z�4�X3@�:G���j��dN��$���a_�9��v��f�p~�-�3�_����0(��Bg��6^XXS���B'��L1@ Z႙d�5� ��;� ��A�t��S��P����?ͿFBU���a���(�aR����`ؚ#�Vh	�A��8�� �m�2�^�V�2��-$�sG�;&�� ����:	:SpbP�<@�@3��^S͈�K�/-0��_�O�d��q�P�5e��c?.�o���0KӪ�~���㩭����R��n�)]�qS��uy�4�n?��ou��|��:aI+����8�%Ym�玪Sm$��V
�i�~��h�p���w���ɻ7Q�^�?�ct�(�/�ֿ��g5X�7k�B{ϢH?�Xnr^�<�.����8}t�]���]Z�ƍ޽=N4iU��g�~��S^19紪�����4Y��ˣY���r=?�yκ����~��*��o=|�aH�z
uG������c�ŏ$�x��SD����6�n~튢J��V9O����_�!q��9�,]���ĉ<?�TU���+���-�����*~:��� T7�|]'�PT��M�aa�B��� oR/��/��81�;�[�O�7��+���w������K�_R�������yUt���+�1��������8�%K�o�O�dIN��Ϧj=��~���#t
�K���}.q�~N���I޵Q78mY�S���+}I��-[T��f��o���2'��=v'�(觚�$����U>�����6̫QT��%�??�ǉ=�a+ô��S��<�Nͻ͂���\W�4�V�H}�vJ7E��N	�L�e6�+��D�*Ǜ�`];�/�h���>v�����Μ6;di�B@���S�����ӟ�g}{�Go��^9�
��g����3}f��S��S�di<������G4���������{DOo�<�<�C�3���\a8n�o_te���!j�7�n�G8�4��������z��O�x��kg�T�:��#yb��H0�1��eds�����'�g�~��Ҧ���nu��J�ފ����D2��y��%�I�Z^4���] �%���`��eqzR�ٍ+u;чR�-]�o�M��EB�H���&��~����3�fD�##71狽;{.��K�9t�1��Lh����l��\RjFtY]�|]ё�`�}��Kv�Q��d��f�S�v>��qt<��'̉f\�L�-p�J��{�ߧ�^��R/5?Y3���\�Y�Țam"`
]jTk���ҽ�\[��k�7��D�:�Tx̻c���U�R��А{��a�R�����*���3*:ۼo��$'��J��B���[Pg��u���װ�"�<��_ds/���x�����3�Q@�E	�s����-�5�k��E0��R��.���~�9��5���Y+��|_��=�W����_�#���&�5�����#�/،�����a��n��>�%Hx���{0 �	p�rҘK�e��^��֢l��	` ^!�k��;�����⢐���A&��4 =T�s{جf��;!�5NZ>#�(�+���$	��>Kԧ⺡�%�Ż|��1U�zհZ_�ae#v��s*��l��Q��x��i g��[o,qĶ��lR�&:�9��ʥ�B`�O3�+i�ޚO��Jf( �DDƐ�ɞ�"��/��?3t�Υ���9/�$iv<�9�j��p��;i��@����]�\�L}��ퟫ\k��$O�ȄF�V���~ِ�qǏ[��K{63�M+�*��D��v�ɝ\��P�~�z|��	� z$b��[&���Z�����L1O�Ó5?����+\���kdŸ����FZ�[C.{�'���P�#~	�g�����;эƯ׍�����ЮsDUgO�n���x3��! ���Z��qOD ��N`W�d�e���L-�`i\'>���>q����� 7ِ\� ��
��qq�N��Q,ZceXz������A�ن���m���~bu���[i�����7r�Z����"N>_ 4(�3r����=Q{�����8����F�`,Ww�~@[=� �0�X�`�hƪScE�u�d����J�[�ըO`K�瓅�(���Lod�����l��-�X�-����8�����;H=�z��X3Н-����]���N���� mu!/}GB��H��ta�M��6<�|�QYX͏�4P��vw6$�����lGQ8��R��\n��� 	.x}�v ֺZd/2ׅ9)cgü3l�-¾M�,���	����/zp�$G
�����(}��w���V�����'׃%1�\	�B؋��]���|�۝ʳ�(L��Jk���ϥ�o�왘@/�֓�����Q�`7�M�3��p����i�m�������Ȩ1^��������m��      1   F  x���Kn�H�ut�\ FWuUW�v$ES��%>��X�����X>�h7��B��E������4|B�����Ϡsvs�?E��cQ��I��/!P]s�{yz��a�������˛�n�e;��%Ε�T�;�b�Ms�)����z�uJY��C�O�� �?<�`��Ý�4��ߵ���B88_c�a���$�4+n4RJͨ��
�!VxrI�jB�jw�ܣL_���&�撧���.^���wr��~]��wh/���	FN*Pc��!�0�����C�����)E�������B[���	���"�n�iA �tñp�߰�Kh��kh�����Ǖ��:��!;�EphZ����Jw�*�hɛN'~U�~A�c�P�J	I�(���S�Y����o7�8��x���]g������D̃C��N��c���t��|�]�����3���6/X���(|����!ӓm(�b�[;�_�o1É��q�^@"�u��]�	|�8��5!�n'e���]���@f����7��M�.�nq�}C��{�p�*{���}�8^��4��1�Ɩ��T����i��}��i8�X���Y�<"q��Si+,��`�b��#ӹ�t=�� ����N+9,�Z!im�rB�g�������/Ϗ����~�4V�q����J�ƅG>�<�,:�h�����4�,���>�究�Qm/��!N�O���X�&XY�SJ-9�5��D�MW�]���y>�By]�� �O4��;��W^YL/\�8�;8f�_�g�9�9�U0��.\�8�;8 nF�� ����]{�|.\ �= ��W����9�      /     x���ɖ�J� �qާ��\�79��{E]5�A����8u�ߪ�g1���@{[%�_U��62�@� ��@����H2ȿ����.};K�{Vؘ�ɳ��vH!�l.80�bF{�9��\ ��{��ΣP�f��f���	7�Y�.B�z\ۨ�3Y�~��^ނ��Z�����|­��h3�"L�I#�g-�Oyf?w��SD$@�K��+�����Zl�}ꚗO
�6ɬ���O����ږ��Z��Nfv���eH��r�s�̊z�]I�{~p����[N�;?�!���[=��::�U��UϪ2��%�9�:^����;�(\�9B�yͬI����A�yh�u]H3�6�3�$�Sk:t¿�>�^����|uN�Xw<��~ѷd"$������i� ��Cʏ��UM=�5��������c�Q���A�~��Y���>8Ү2�e�>�	꠳PlSG����v�p>u��)8�v^�>���x�$|�w��%��V�)h��M�n�0�۹"�W����F.�������M���|��΄�{�$�9���~�2��M�Jzqʛ��ve��W;��|�}� �f^���t�O[y�_�,'a��hm��#N
e:��h��%�լ���g�QS��R�i9��Κ�Hۚi�u�j�̫ͳX���W���.x.63�������Yo¨}㾽nnF�ϪNJϪ*�4�)��w�nB/�u��0k�I�%4�4dyPQ�ϻtR����-�/��l�{���	��ī�S}{����z���|�����N��M�)|�Q�M��n��؜��N��{5��E�e?���a��2N7~/��H�OD6�/��B���� 0���r�ѯ�[�t���;U��}����%y�M�h/�P�m8�E��vA���n���[�I�z4�i�n]�a��N�sl�9.�Lm]��'JJ��J-j�� �+�myYŘ�Y��u�vU�İ
b/t��8��)��[���	,7)�D'��I�e�Y��*�%�УiB�R�����v���Ĺ��������ST�|��;L�d�u��r^}>V���X0?l�c����~1MIS�~�"��+Y$W�.;�._68M��Lռ��'�=�����������N/M�Q���EJ����������~ ���j[d��(
5��JAz�������w!�FE��j�>���R\���2H5������ܯhU��Vz�U��>���F��<�.���V��3����6�3;��ĉ�OT���z�wi�5������u諒���`�7;L�!s���3��(E��GUԎ��M=�O��hb'�?�9L�`?��(m��:/�!J2踅<�Ҵ��i�����������
ݛT� �3++աf1�Q�e��N�t2�M�Jj?-zV�&����������k��up2�q�=T�:��N{�YX������,v��1^e�LZ���q3O���6��t*�E�������|�G�
�C�J��N�Ī�}���uh�V�;��}�{�?V�����nבraiL=�;�O�`Nx���
��J�p���ç���So��"베��{�P���F]���o9iҙ��v�߯�w�5yP�.��zgv�0��8jUF _f�v�t����?~#	�_�_O����:�<r�*:��@�w̋���g<?J)2���� mQ�D2y�ӵ _J�+��=l-a�R�]�������%�#97&�XՌ/�!�\�(��x
U�\?B����0f|@l
�k��3)�;��b"�&��d� �GpzgS0cp	���y �� ���b����b���>���qsE�۽���������Ag{($�)d"N�CP&�-F줽a��3 �	FN��@�.��wJC�Ճ��i���щ��P�����H�Z�ׇ����	�F9;�n�ٳ9K(4]��n|�Wy�$+z��'�x��b���=!���gw@֝\��s�T_AC�������N 빟���&g�S�j�'�� ���xjB*nB��]+��g�����S&�8V���'����.H��R��H�?Ŀme7�����s	 ����w����5:o�Q�ٓN��-AH^.\gK�_=4w�Rp��[�;��7�=!��O��wD�O!��v4��:��"G���\oO��zڔl1�'�1ܞ��_T�$ԁ��r��u��eä�ЎYh*3�5���P��@��te���|=�o	�tF��R�a��W���_-�����F��m�_��^��XNU��|~�dr�<�����#�1�]p�L�yʅ|)�'l�@�����=81�����+`y�j֜����~C֧�;A�;��.ɗ�8�s����ӓ= �'Ɩ+���8�%��W���D�/O�<	��λ�.��2���5{��s�6�����7�H?�N�]�	z�3�3 �@��@T���<;>0�*�hq=��5"�V��P_�Y �m.���b��Ҁ� W*ȯlJg;ɶ�BY�1@�Sl0�p�C�U{;�o:�';*��y	�̋3��8�^�^�p�99��F���~5U5�0,s�
��9z �9[��)�k"�
4@G������`)�SL��DCh0�d�$Pn fϥ�)[�W%��@�Ty/%�������3�Q��`l���� I(;��a	4=�0�d;;�<*T/������y[���	gՕOY�t�����B?�v*5���X���V�������UM5��$��1��9	����bڒ�$��̛0qx�ݩ[A��}7��6%��ӂ�,/tWf��
��R4SQ|~{�T�\BC.��d,)���ʸ������ۑ��������Bw*�-�F�#惄����N�:�C��]��3pX+�o ��Y��Y ~3�6TI°��z�ZL �
r`�%HM�_]/�.U"�M���!Se���i�^�c��зj�*�ˋ�-@�m�Z/9Z
�0՞���S��)�g�\��Đ��FM�q�{1��#]��Z� ��	L7�/I���hBM�͐�.y���Y����3%?��L����}�C�B�jBqG�G�G�G�G�G�G���?���}��,?���'2�N9�_%?�`������+��+��+�ߣ���_��|��+ЯO�*������������������K���b"���������Mȗ_�������C�o�G�G�G�G�G�G��!��c��B�c4�?�?�?�?�?�?��������O�7���k�G�G�G�G�G�G�����巊m:�?�?�?�?�?�?��������� ���W���������]�'_�o���q���G�G�G�G�G�G����_�!�F�0^�?�?�?�?�?�?��ۘϾ�ߘϿ�2����?�?�?�?�?�?��ۘϿ�҉�ϯ[�F�����,#��ů{�:�o�竿ޭV��������W-~���.~��K��~0�����������Zc�5�Zc�5�Zc�5~�ZC|��X�/�	��[�/��������m������ɔW�     