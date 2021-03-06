PGDMP     *                    z            dischig    14.1 (Debian 14.1-1.pgdg110+1)    14.1 (Debian 14.1-1.pgdg110+1) :    6           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            7           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            8           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            9           1262    16861    dischig    DATABASE     \   CREATE DATABASE dischig WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.UTF-8';
    DROP DATABASE dischig;
                postgres    false            :           0    0    DATABASE dischig    ACL     (   GRANT ALL ON DATABASE dischig TO duser;
                   postgres    false    3385            ?            1259    16868    _chatter    TABLE     J  CREATE TABLE public._chatter (
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
       public         heap    duser    false            ?            1259    16884    _comment    TABLE     ?   CREATE TABLE public._comment (
    id bigint NOT NULL,
    date timestamp without time zone NOT NULL,
    value text NOT NULL,
    chatter_id text,
    message_id bigint
);
    DROP TABLE public._comment;
       public         heap    duser    false            ?            1259    16883    _comment_id_seq    SEQUENCE     x   CREATE SEQUENCE public._comment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public._comment_id_seq;
       public          duser    false    212            ;           0    0    _comment_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public._comment_id_seq OWNED BY public._comment.id;
          public          duser    false    211            ?            1259    16863    _conduit_version_pgsql    TABLE     ?   CREATE TABLE public._conduit_version_pgsql (
    versionnumber integer NOT NULL,
    dateofupgrade timestamp without time zone NOT NULL
);
 *   DROP TABLE public._conduit_version_pgsql;
       public         heap    duser    false            ?            1259    16893 
   _following    TABLE     f   CREATE TABLE public._following (
    id bigint NOT NULL,
    chatter_id text,
    follower_id text
);
    DROP TABLE public._following;
       public         heap    duser    false            ?            1259    16892    _following_id_seq    SEQUENCE     z   CREATE SEQUENCE public._following_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public._following_id_seq;
       public          duser    false    214            <           0    0    _following_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public._following_id_seq OWNED BY public._following.id;
          public          duser    false    213            ?            1259    16910    _like    TABLE     ?   CREATE TABLE public._like (
    id bigint NOT NULL,
    date timestamp without time zone NOT NULL,
    chatter_id text,
    message_id bigint
);
    DROP TABLE public._like;
       public         heap    duser    false            ?            1259    16909    _like_id_seq    SEQUENCE     u   CREATE SEQUENCE public._like_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public._like_id_seq;
       public          duser    false    218            =           0    0    _like_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public._like_id_seq OWNED BY public._like.id;
          public          duser    false    217            ?            1259    16900    _message    TABLE     ?   CREATE TABLE public._message (
    id bigint NOT NULL,
    value text NOT NULL,
    isprivate boolean DEFAULT false NOT NULL,
    date timestamp without time zone NOT NULL,
    from_id text,
    to_id text
);
    DROP TABLE public._message;
       public         heap    duser    false            ?            1259    16899    _message_id_seq    SEQUENCE     x   CREATE SEQUENCE public._message_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public._message_id_seq;
       public          duser    false    216            >           0    0    _message_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public._message_id_seq OWNED BY public._message.id;
          public          duser    false    215            x           2604    16887    _comment id    DEFAULT     j   ALTER TABLE ONLY public._comment ALTER COLUMN id SET DEFAULT nextval('public._comment_id_seq'::regclass);
 :   ALTER TABLE public._comment ALTER COLUMN id DROP DEFAULT;
       public          duser    false    211    212    212            y           2604    16896    _following id    DEFAULT     n   ALTER TABLE ONLY public._following ALTER COLUMN id SET DEFAULT nextval('public._following_id_seq'::regclass);
 <   ALTER TABLE public._following ALTER COLUMN id DROP DEFAULT;
       public          duser    false    213    214    214            |           2604    16913    _like id    DEFAULT     d   ALTER TABLE ONLY public._like ALTER COLUMN id SET DEFAULT nextval('public._like_id_seq'::regclass);
 7   ALTER TABLE public._like ALTER COLUMN id DROP DEFAULT;
       public          duser    false    217    218    218            z           2604    16903    _message id    DEFAULT     j   ALTER TABLE ONLY public._message ALTER COLUMN id SET DEFAULT nextval('public._message_id_seq'::regclass);
 :   ALTER TABLE public._message ALTER COLUMN id DROP DEFAULT;
       public          duser    false    215    216    216            +          0    16868    _chatter 
   TABLE DATA           ?   COPY public._chatter (id, email, password, nickname, isconfirmedemail, phonenumber, phonenumberconfirmtoken, isconfirmedphonenumber, secret) FROM stdin;
    public          duser    false    210   ^B       -          0    16884    _comment 
   TABLE DATA           K   COPY public._comment (id, date, value, chatter_id, message_id) FROM stdin;
    public          duser    false    212   {B       *          0    16863    _conduit_version_pgsql 
   TABLE DATA           N   COPY public._conduit_version_pgsql (versionnumber, dateofupgrade) FROM stdin;
    public          duser    false    209   ?B       /          0    16893 
   _following 
   TABLE DATA           A   COPY public._following (id, chatter_id, follower_id) FROM stdin;
    public          duser    false    214   ?B       3          0    16910    _like 
   TABLE DATA           A   COPY public._like (id, date, chatter_id, message_id) FROM stdin;
    public          duser    false    218   ?B       1          0    16900    _message 
   TABLE DATA           N   COPY public._message (id, value, isprivate, date, from_id, to_id) FROM stdin;
    public          duser    false    216   C       ?           0    0    _comment_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public._comment_id_seq', 1, false);
          public          duser    false    211            @           0    0    _following_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public._following_id_seq', 1, false);
          public          duser    false    213            A           0    0    _like_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public._like_id_seq', 1, false);
          public          duser    false    217            B           0    0    _message_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public._message_id_seq', 1, false);
          public          duser    false    215            ?           2606    16878    _chatter _chatter_email_key 
   CONSTRAINT     W   ALTER TABLE ONLY public._chatter
    ADD CONSTRAINT _chatter_email_key UNIQUE (email);
 E   ALTER TABLE ONLY public._chatter DROP CONSTRAINT _chatter_email_key;
       public            duser    false    210            ?           2606    16880    _chatter _chatter_nickname_key 
   CONSTRAINT     ]   ALTER TABLE ONLY public._chatter
    ADD CONSTRAINT _chatter_nickname_key UNIQUE (nickname);
 H   ALTER TABLE ONLY public._chatter DROP CONSTRAINT _chatter_nickname_key;
       public            duser    false    210            ?           2606    16882 -   _chatter _chatter_phonenumberconfirmtoken_key 
   CONSTRAINT     {   ALTER TABLE ONLY public._chatter
    ADD CONSTRAINT _chatter_phonenumberconfirmtoken_key UNIQUE (phonenumberconfirmtoken);
 W   ALTER TABLE ONLY public._chatter DROP CONSTRAINT _chatter_phonenumberconfirmtoken_key;
       public            duser    false    210            ?           2606    16876    _chatter _chatter_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public._chatter
    ADD CONSTRAINT _chatter_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public._chatter DROP CONSTRAINT _chatter_pkey;
       public            duser    false    210            ?           2606    16891    _comment _comment_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public._comment
    ADD CONSTRAINT _comment_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public._comment DROP CONSTRAINT _comment_pkey;
       public            duser    false    212            ~           2606    16867 ?   _conduit_version_pgsql _conduit_version_pgsql_versionnumber_key 
   CONSTRAINT     ?   ALTER TABLE ONLY public._conduit_version_pgsql
    ADD CONSTRAINT _conduit_version_pgsql_versionnumber_key UNIQUE (versionnumber);
 i   ALTER TABLE ONLY public._conduit_version_pgsql DROP CONSTRAINT _conduit_version_pgsql_versionnumber_key;
       public            duser    false    209            ?           2606    16898    _following _following_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public._following
    ADD CONSTRAINT _following_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public._following DROP CONSTRAINT _following_pkey;
       public            duser    false    214            ?           2606    16915    _like _like_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public._like
    ADD CONSTRAINT _like_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public._like DROP CONSTRAINT _like_pkey;
       public            duser    false    218            ?           2606    16908    _message _message_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public._message
    ADD CONSTRAINT _message_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public._message DROP CONSTRAINT _message_pkey;
       public            duser    false    216            ?           1259    16916    _comment_chatter_id_idx    INDEX     R   CREATE INDEX _comment_chatter_id_idx ON public._comment USING btree (chatter_id);
 +   DROP INDEX public._comment_chatter_id_idx;
       public            duser    false    212            ?           1259    16922    _comment_message_id_idx    INDEX     R   CREATE INDEX _comment_message_id_idx ON public._comment USING btree (message_id);
 +   DROP INDEX public._comment_message_id_idx;
       public            duser    false    212            ?           1259    16930    _following_chatter_id_idx    INDEX     V   CREATE INDEX _following_chatter_id_idx ON public._following USING btree (chatter_id);
 -   DROP INDEX public._following_chatter_id_idx;
       public            duser    false    214            ?           1259    16936    _following_follower_id_idx    INDEX     X   CREATE INDEX _following_follower_id_idx ON public._following USING btree (follower_id);
 .   DROP INDEX public._following_follower_id_idx;
       public            duser    false    214            ?           1259    16956    _like_chatter_id_idx    INDEX     L   CREATE INDEX _like_chatter_id_idx ON public._like USING btree (chatter_id);
 (   DROP INDEX public._like_chatter_id_idx;
       public            duser    false    218            ?           1259    16962    _like_message_id_idx    INDEX     L   CREATE INDEX _like_message_id_idx ON public._like USING btree (message_id);
 (   DROP INDEX public._like_message_id_idx;
       public            duser    false    218            ?           1259    16942    _message_from_id_idx    INDEX     L   CREATE INDEX _message_from_id_idx ON public._message USING btree (from_id);
 (   DROP INDEX public._message_from_id_idx;
       public            duser    false    216            ?           1259    16948    _message_to_id_idx    INDEX     H   CREATE INDEX _message_to_id_idx ON public._message USING btree (to_id);
 &   DROP INDEX public._message_to_id_idx;
       public            duser    false    216            ?           2606    16917 !   _comment _comment_chatter_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public._comment
    ADD CONSTRAINT _comment_chatter_id_fkey FOREIGN KEY (chatter_id) REFERENCES public._chatter(id) ON DELETE SET NULL;
 K   ALTER TABLE ONLY public._comment DROP CONSTRAINT _comment_chatter_id_fkey;
       public          duser    false    3206    212    210            ?           2606    16923 !   _comment _comment_message_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public._comment
    ADD CONSTRAINT _comment_message_id_fkey FOREIGN KEY (message_id) REFERENCES public._message(id) ON DELETE SET NULL;
 K   ALTER TABLE ONLY public._comment DROP CONSTRAINT _comment_message_id_fkey;
       public          duser    false    212    3217    216            ?           2606    16931 %   _following _following_chatter_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public._following
    ADD CONSTRAINT _following_chatter_id_fkey FOREIGN KEY (chatter_id) REFERENCES public._chatter(id) ON DELETE SET NULL;
 O   ALTER TABLE ONLY public._following DROP CONSTRAINT _following_chatter_id_fkey;
       public          duser    false    210    3206    214            ?           2606    16937 &   _following _following_follower_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public._following
    ADD CONSTRAINT _following_follower_id_fkey FOREIGN KEY (follower_id) REFERENCES public._chatter(id) ON DELETE SET NULL;
 P   ALTER TABLE ONLY public._following DROP CONSTRAINT _following_follower_id_fkey;
       public          duser    false    214    3206    210            ?           2606    16957    _like _like_chatter_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public._like
    ADD CONSTRAINT _like_chatter_id_fkey FOREIGN KEY (chatter_id) REFERENCES public._chatter(id) ON DELETE SET NULL;
 E   ALTER TABLE ONLY public._like DROP CONSTRAINT _like_chatter_id_fkey;
       public          duser    false    218    3206    210            ?           2606    16963    _like _like_message_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public._like
    ADD CONSTRAINT _like_message_id_fkey FOREIGN KEY (message_id) REFERENCES public._message(id) ON DELETE SET NULL;
 E   ALTER TABLE ONLY public._like DROP CONSTRAINT _like_message_id_fkey;
       public          duser    false    218    3217    216            ?           2606    16943    _message _message_from_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public._message
    ADD CONSTRAINT _message_from_id_fkey FOREIGN KEY (from_id) REFERENCES public._chatter(id) ON DELETE CASCADE;
 H   ALTER TABLE ONLY public._message DROP CONSTRAINT _message_from_id_fkey;
       public          duser    false    210    3206    216            ?           2606    16949    _message _message_to_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public._message
    ADD CONSTRAINT _message_to_id_fkey FOREIGN KEY (to_id) REFERENCES public._chatter(id) ON DELETE CASCADE;
 F   ALTER TABLE ONLY public._message DROP CONSTRAINT _message_to_id_fkey;
       public          duser    false    210    216    3206            +      x?????? ? ?      -      x?????? ? ?      *   *   x?3?4202?50?54V02?22?20?366647?????? k??      /      x?????? ? ?      3      x?????? ? ?      1      x?????? ? ?     