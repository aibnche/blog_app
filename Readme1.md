
# Blog App

A Flutter blog application built with clean architecture, BLoC pattern, and Supabase backend integration.

## 🏗️ Architecture Overview

This application follows **Clean Architecture** principles with a clear separation of concerns across multiple layers:

### 📁 Project Structure

```
lib/
├── core/                     # Core functionality shared across features
│   ├── common/cubits/       # Common cubits across all features
│   ├── error/               # Error handling
│   ├── secrets/             # App secrets and configuration
│   ├── theme/               # App theming
│   ├── usecase/             # Base use case interface
│   └── utils/               # Utility functions
├── features/                # Feature-based modules
│   ├── auth/                # Authentication feature
│   └── blog/                # Blog feature
└── init_dependencies.dart   # Dependency injection setup
```

## 🔧 State Management

### BLoC vs Cubit Usage

The app strategically uses both **BLoC** and **Cubit** based on complexity:

#### When to use BLoC:
- Complex state management needs
- Multiple events and states handling
- Advanced business logic requirements
- Event-driven architecture

#### When to use Cubit:
- Simple state management needs
- Single state with functions that emit states
- Straightforward state transitions

> **Note**: Both BLoC and Cubit are used to communicate with the UI layer effectively.

### State Management Implementation

#### AppUserCubit
```dart
// Cubit to manage the application user state
// Located in core/common/cubits/ as it's shared across features
```

**States:**
- `AppUserInitial`: Initial state when app starts
- `AppUserLoggedIn`: State containing user data when authenticated

**Key Features:**
- Core cannot depend on features, maintaining clean architecture
- Other features can extend this state if needed
- Single active state at any time (no multiple simultaneous states)

#### AuthBloc
```dart
// AuthBloc class that extends Bloc and manages authentication events and states
// Handles complex authentication logic with multiple events
```

**Responsibilities:**
- User sign up/sign in operations
- Session management
- User authentication status checking
- Updating AppUserCubit with user data

## 🔄 Dependency Injection

### Service Locator Pattern

The app uses **GetIt** for dependency injection with a service locator pattern:

```dart
// init_dependencies.dart structure:
```

#### Registration Flow:
1. **Data Source**: Talks to Supabase backend
2. **Repository**: Handles business logic
3. **Use Cases**: Contain specific business operations
4. **Bloc**: State management layer
5. **Core**: Shared application state

#### Lazy Initialization Benefits:
- **Registration vs Instantiation**: Dependencies are registered as "recipes" but not created until needed
- **Dependency Resolution**: GetIt resolves all dependencies when first requested
- **Single Instance**: `registerLazySingleton` ensures only one instance throughout the app

## 🚀 Application Flow

### App Initialization
```dart
// main.dart execution flow:
1. WidgetsFlutterBinding.ensureInitialized()
2. await initDependencies() // ALL registrations complete
3. MultiBlocProvider setup // THEN instantiation happens
4. MyApp widget creation
```

### Authentication Flow

#### Startup Check
```dart
// initState(): Runs when app starts to automatically check 
// if user is already logged in from a previous session
context.read<AuthBloc>().add(AuthIsUserLoggedIn());
```

#### State-Based Navigation
```dart
// BlocSelector automatically knows current state by listening to AppUserCubit
BlocSelector<AppUserCubit, AppUserState, bool>(
  selector: (state) => state is AppUserLoggedIn,
  builder: (context, isLoggedIn) {
    if (isLoggedIn) return const BlogPage();
    return const SignInPage();
  },
)
```

**How BlocSelector Works:**
1. **Initial State**: AppUserCubit starts with `AppUserInitial()`
2. **State Changes**: When cubit emits new state (like `AppUserLoggedIn(user)`), BlocSelector receives it automatically
3. **Selector Function**: Runs every time state changes to determine UI updates

## 📡 Data Layer

### Repository Pattern

```dart
// Concrete implementation of AuthRepository
// Relies on AuthRemoteDataSource for actual data operations
```

### Remote Data Source

```dart
// Concerned with remote data source operations for authentication
// Concrete implementation that relies on Supabase client
```

### Models

#### User Model Implementation
```dart
// Two approaches demonstrated:

// Method 1: Traditional constructor
UserModel({
  required String id,
  required String name, 
  required String email,
}) : super(id: id, name: name, email: email);

// Method 2: Using "super" parameters (Dart 2.17+)
// Passing parameters directly to super class (User)
```

**JSON Conversion:**
```dart
// Used to convert JSON map into UserModel instance
UserModel.fromJson(Map<String, dynamic> json)
```

## 🔐 Authentication & Security

### Supabase Integration
```dart
// App secrets and Supabase configuration
static const supabaseUrl = 'https://zfegloyylvscvbhvrayl.supabase.co';
```

### Session Management
```dart
// Current user session getter
Session? get currentUserSession => supabaseClient.auth.currentSession;
```

## 🎨 UI Components

### Blog Editor
```dart
// Multi-line input support for blog content
maxLines: null, // Allows for multi-line input
```

### Image Handling
```dart
// State management for image selection
setState(() {}); // Refresh UI when image changes
// Build function rebuilds only if image is changed
```

## 🔧 Use Cases

### Functional Programming Approach

```dart
// Use cases represent the return type of operations
Future<Either<Failure, SuccessType>> call(Params params);
```

**Call Operator Pattern:**
- Makes classes callable like functions
- Clean API for business logic execution  
- Instead of `userSignUp.execute(params)` use `userSignUp(params)`

### Error Handling

#### Either Pattern
```dart
Future<Either<Failure, User>> // Two possible return types
```

**Benefits:**
- **Left side (Failure)**: Error/failure cases
- **Right side (User)**: Success cases with actual data
- **Type-safe error handling** without exceptions
- Forces explicit handling of both success and failure cases

## 🛠️ Development Guidelines

### State Management Rules
1. **Single Active State**: Only one state active at any time
2. **Reactive Updates**: BlocSelector automatically rebuilds on state changes
3. **Clean Dependencies**: Core cannot depend on features
4. **Shared State**: Common cubits accessible across all features

### Architecture Principles
1. **Clean Architecture**: Clear separation of concerns
2. **Dependency Injection**: Loose coupling between layers
3. **Repository Pattern**: Abstract data source interactions
4. **Use Case Pattern**: Encapsulate business logic
5. **Functional Error Handling**: Type-safe error management

### Code Organization
- **Feature-based modules**: Each feature is self-contained
- **Shared core**: Common functionality in core directory
- **Dependency isolation**: Features don't directly depend on each other
- **Interface segregation**: Abstract contracts for data sources and repositories

## 🗄️ Database Schema

### User Profiles
```sql
-- Create a table for public profiles
create table profiles (
  id uuid references auth.users not null primary key,
  updated_at timestamp with time zone,
  name text,
  constraint name_length check (char_length(name) >= 3)
);
```

### Blog Posts
```sql
create table blogs (
  id uuid not null primary key,
  updated_at timestamp with time zone,
  title text not null,
  content text not null,
  poster_id uuid not null,
  image_url text,
  topics text array,
  foreign key (poster_id) references public.profiles(id)
);
```

### Security Policies
- **Row Level Security (RLS)** enabled on all tables
- **Public read access** for profiles and blogs
- **User-specific write access** for own content
- **Automatic profile creation** trigger on user signup

### Storage Configuration
```sql
-- Blog image storage bucket
insert into storage.buckets (id, name)
  values ('blog_images', 'blog_images');
```

## 🚀 Getting Started

1. **Clone the repository**
2. **Install dependencies**: `flutter pub get`
3. **Configure Supabase**: Update secrets in `core/secrets/app_secrets.dart`
4. **Set up database**: Run the provided SQL schema
5. **Run the app**: `flutter run`

## 🧪 Testing Strategy

The architecture supports comprehensive testing:
- **Unit Tests**: Individual use cases and business logic
- **Widget Tests**: UI components and state management
- **Integration Tests**: End-to-end user flows
- **Mock Dependencies**: Easy mocking through dependency injection

## 📚 Key Technologies

- **Flutter**: Cross-platform mobile development
- **BLoC/Cubit**: State management
- **Supabase**: Backend as a Service
- **GetIt**: Dependency injection
- **Either (fpdart)**: Functional error handling
- **Clean Architecture**: Project structure

---

This README reflects the actual implementation and architectural decisions documented throughout the codebase comments.
